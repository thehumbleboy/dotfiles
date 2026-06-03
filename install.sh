#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

# ──────────────────────────────────────────────
# Detect package manager
# ──────────────────────────────────────────────
detect_pkg_manager() {
    if command -v apt &>/dev/null; then
        PKG_MANAGER="apt"
        INSTALL_CMD="sudo apt update && sudo apt install -y"
    elif command -v dnf &>/dev/null; then
        PKG_MANAGER="dnf"
        INSTALL_CMD="sudo dnf install -y"
    elif command -v pacman &>/dev/null; then
        PKG_MANAGER="pacman"
        INSTALL_CMD="sudo pacman -S --noconfirm"
    elif command -v zypper &>/dev/null; then
        PKG_MANAGER="zypper"
        INSTALL_CMD="sudo zypper install -y"
    elif command -v apk &>/dev/null; then
        PKG_MANAGER="apk"
        INSTALL_CMD="sudo apk add"
    else
        echo "Error: No supported package manager found."
        exit 1
    fi
    echo "Detected package manager: $PKG_MANAGER"
}

# ──────────────────────────────────────────────
# Install packages
# ──────────────────────────────────────────────
install_packages() {
    echo "Installing core packages..."

    case "$PKG_MANAGER" in
        apt)
            sudo apt update
            sudo apt install -y zsh git curl tmux kitty
            ;;
        dnf)
            sudo dnf install -y zsh git curl tmux kitty
            ;;
        pacman)
            sudo pacman -S --noconfirm zsh git curl tmux kitty
            ;;
        zypper)
            sudo zypper install -y zsh git curl tmux kitty
            ;;
        apk)
            sudo apk add zsh git curl tmux kitty
            ;;
    esac
}

# ──────────────────────────────────────────────
# Install Neovim (latest stable from GitHub)
# ──────────────────────────────────────────────
install_neovim() {
    if command -v nvim &>/dev/null; then
        echo "Neovim is already installed: $(nvim --version | head -1)"
        return
    fi

    echo "Installing Neovim..."

    case "$PKG_MANAGER" in
        pacman)
            sudo pacman -S --noconfirm neovim
            ;;
        *)
            curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
            sudo rm -rf /opt/nvim
            sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
            sudo ln -sf /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim
            rm -f nvim-linux-x86_64.tar.gz
            ;;
    esac

    echo "Neovim installed: $(nvim --version | head -1)"
}

# ──────────────────────────────────────────────
# Install Oh My Zsh
# ──────────────────────────────────────────────
install_oh_my_zsh() {
    if [ -d "$HOME/.oh-my-zsh" ]; then
        echo "Oh My Zsh is already installed."
    else
        echo "Installing Oh My Zsh..."
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    fi
}

# ──────────────────────────────────────────────
# Install Zsh plugins & Powerlevel10k
# ──────────────────────────────────────────────
install_zsh_plugins() {
    ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

    if [ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]; then
        echo "Installing Powerlevel10k..."
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k"
    else
        echo "Powerlevel10k is already installed."
    fi

    if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
        echo "Installing zsh-autosuggestions..."
        git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
    else
        echo "zsh-autosuggestions is already installed."
    fi

    if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
        echo "Installing zsh-syntax-highlighting..."
        git clone https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
    else
        echo "zsh-syntax-highlighting is already installed."
    fi
}

# ──────────────────────────────────────────────
# Install TPM (Tmux Plugin Manager)
# ──────────────────────────────────────────────
install_tpm() {
    if [ -d "$HOME/.tmux/plugins/tpm" ]; then
        echo "TPM is already installed."
    else
        echo "Installing TPM (Tmux Plugin Manager)..."
        git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
    fi
}

# ──────────────────────────────────────────────
# Symlink dotfiles
# ──────────────────────────────────────────────
link_file() {
    local src="$1"
    local dst="$2"

    mkdir -p "$(dirname "$dst")"

    if [ -L "$dst" ]; then
        rm "$dst"
    elif [ -f "$dst" ] || [ -d "$dst" ]; then
        echo "Backing up existing $dst -> ${dst}.bak"
        mv "$dst" "${dst}.bak"
    fi

    ln -s "$src" "$dst"
    echo "Linked $src -> $dst"
}

symlink_dotfiles() {
    echo "Symlinking dotfiles..."

    # Zsh
    link_file "$DOTFILES_DIR/zsh/.zshrc" "$HOME/.zshrc"

    # Neovim
    link_file "$DOTFILES_DIR/nvim" "$HOME/.config/nvim"

    # Tmux
    link_file "$DOTFILES_DIR/tmux/tmux.conf" "$HOME/.tmux.conf"

    # Kitty
    link_file "$DOTFILES_DIR/kitty" "$HOME/.config/kitty"
}

# ──────────────────────────────────────────────
# Set Zsh as default shell
# ──────────────────────────────────────────────
set_default_shell() {
    if [ "$SHELL" != "$(which zsh)" ]; then
        echo "Changing default shell to zsh..."
        chsh -s "$(which zsh)"
    else
        echo "Default shell is already zsh."
    fi
}

# ──────────────────────────────────────────────
# Main
# ──────────────────────────────────────────────
main() {
    echo "=========================================="
    echo "  Dotfiles Installer"
    echo "=========================================="
    echo ""

    detect_pkg_manager
    install_packages
    install_neovim
    install_oh_my_zsh
    install_zsh_plugins
    install_tpm
    symlink_dotfiles
    set_default_shell

    echo ""
    echo "=========================================="
    echo "  Installation complete!"
    echo "=========================================="
    echo ""
    echo "Next steps:"
    echo "  1. Restart your terminal (or run: exec zsh)"
    echo "  2. Powerlevel10k will prompt you to configure on first launch"
    echo "  3. Open tmux and press prefix + I (Ctrl-Space + I) to install tmux plugins"
    echo "  4. Open nvim — Lazy.nvim will auto-install plugins on first launch"
    echo ""
}

main "$@"

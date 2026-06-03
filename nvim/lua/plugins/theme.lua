return {
    {
        "catppuccin/nvim",
        name = "catppuccin",
        lazy = false, priority = 1000,
        config = function()
            require("catppuccin").setup({ flavour = "mocha", integrations = { nvimtree = true } })
        end,
    },
    {
        "folke/tokyonight.nvim",
        lazy = false, priority = 1000,
        config = function()
            require("tokyonight").setup({ style = "storm" })
        end,
    },
    {
        "rose-pine/neovim",
        name = "rose-pine",
        lazy = false, priority = 1000,
        config = function()
            require("rose-pine").setup({ variant = "moon" })
        end,
    },
    {
        "ellisonleao/gruvbox.nvim",
        priority = 1000,
        lazy = false,
        config = function()
            require("gruvbox").setup({
                transparent_mode = false,
                contrast = "hard",
            })
        end,
    }
}

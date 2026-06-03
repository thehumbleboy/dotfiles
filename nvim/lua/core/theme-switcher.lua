local M = {}

-- Define where to save the state
local save_file = vim.fn.stdpath("data") .. "/theme.txt"

-- The exact names that will show up in your <leader>th menu
local available_themes = {
    "catppuccin",
    "tokyonight",
    "rose-pine",
    "gruvbox",
    "Terminal Theme", -- Your custom terminal copy option
}

-- Function 1: Save and Apply
function M.set_and_save(theme)
    if theme == "Terminal Theme" then
        vim.opt.termguicolors = false
        vim.cmd("colorscheme default")
    else
        vim.opt.termguicolors = true -- Re-enable for fancy themes
        vim.cmd("colorscheme " .. theme)
    end
    
    local file = io.open(save_file, "w")
    if file then
        file:write(theme)
        file:close()
    end
end

-- Function 2: The Interactive Menu
function M.show_picker()
    vim.ui.select(available_themes, { prompt = "🎨 Choose Theme:" }, function(choice)
        if choice then
            M.set_and_save(choice)
        end
    end)
end

-- Function 3: Load on Startup
function M.load_saved()
    local file = io.open(save_file, "r")
    if file then
        local saved_theme = file:read("*a"):match("^%s*(.-)%s*$")
        file:close()
        
        if saved_theme == "Terminal Theme" then
            vim.opt.termguicolors = false
            vim.cmd("colorscheme default")
            return 
        elseif saved_theme ~= "" then
            vim.opt.termguicolors = true
            local status_ok, _ = pcall(vim.cmd, "colorscheme " .. saved_theme)
            if status_ok then return end
        end
    end
    -- Fallback
    vim.opt.termguicolors = true
    vim.cmd("colorscheme catppuccin")
end

-- Map <leader>th to open the picker
vim.keymap.set("n", "<leader>th", M.show_picker, { desc = "Select Theme" })

return M

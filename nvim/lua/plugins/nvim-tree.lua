return {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    dependencies = {
        "nvim-tree/nvim-web-devicons",
    },
    config = function()
        require("nvim-tree").setup({
            view = {
                width = 30, -- Set the width of the explorer window
            },
            filters = {
                dotfiles = false, -- Show hidden files (like .gitignore)
            },
            actions = {
                open_file = {
                    quit_on_open = true, -- Close the explorer when you open a file
                },
            },
        })
    end,
}

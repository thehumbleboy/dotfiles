local keymap = vim.keymap

-- Clear search highlights on pressing <ESC>
keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Quick save
keymap.set("n", "<leader>w", "<cmd>w<CR>", { desc = "Save file" })

-- File explorer
keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" })

-- increment/decrement numbers
keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number"})
keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number"})

local opt = vim.opt

opt.number = true         -- Show line numbers
opt.relativenumber = true -- Relative line numbers for jumping
opt.tabstop = 4           -- 4 spaces for a tab
opt.shiftwidth = 4        -- 4 spaces for indenting
opt.expandtab = true      -- Convert tabs to spaces
opt.smartindent = true    -- Auto indent new lines
opt.wrap = false          -- Don't wrap long lines
opt.clipboard = "unnamedplus" -- Use system clipboard

-- search settings
opt.ignorecase = true -- ignore case when searching
opt.smartcase = true -- Assumes case sensitive

-- termguicolors
opt.termguicolors = true
opt.background = "dark"

--backspace 
opt.backspace = "indent,eol,start"

-- split windows
opt.splitright = true
opt.splitbelow = true

opt.fillchars:append({ eob = " " })

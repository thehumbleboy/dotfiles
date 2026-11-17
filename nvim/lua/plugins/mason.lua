return {
  {
    "williamboman/mason.nvim",
    config = true,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "neovim/nvim-lspconfig", -- Used to pull modern server templates automatically
      "saghen/blink.cmp",     -- Pulls autocomplete capabilities
    },
    config = function()
      local mason_lspconfig = require("mason-lspconfig")
      local blink = require("blink.cmp")

      -- Initialize mason-lspconfig without hardcoding specific servers
      mason_lspconfig.setup()

      -- Fetch modern autocomplete capabilities from blink.cmp
      local capabilities = blink.get_lsp_capabilities()

      -- Automatically register and enable any server installed via Mason
      for _, server in ipairs(mason_lspconfig.get_installed_servers()) do
        
        -- 1. Modify the native config block to include your autocomplete capabilities
        vim.lsp.config(server, {
          capabilities = capabilities,
        })
        
        -- 2. Explicitly tell Neovim 0.11+ to listen to and enable this server
        vim.lsp.enable(server)
      end
    end,
  },
}


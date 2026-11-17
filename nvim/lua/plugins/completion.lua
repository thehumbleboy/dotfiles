return {
  {
    'saghen/blink.cmp',
    dependencies = 'rafamadriz/friendly-snippets',
    version = '*',

    opts = {
      -- Change 'default' to 'super-tab' to bind mappings to Tab and Shift+Tab
      keymap = { 
        preset = 'super-tab',
        
        -- Optional: Keeps 'Enter' mapping active if you still want it alongside Tab, 
        -- otherwise remove this line to completely dedicate selection to Tab.
        ['<CR>'] = { 'accept', 'fallback' },
      },

      completion = {
        menu = { auto_show = true },
        list = {
          selection = { preselect = false, auto_insert = true }
        },
      },

      -- Your existing code-only filter rules
      sources = {
        default = { 'lsp', 'snippets' },
        
        transform_items = function(_, items)
          return vim.tbl_filter(function(item)
            return item.kind ~= 1 -- Discard plain Text suggestions
          end, items)
        end,
      },

      appearance = {
        use_nvim_cmp_as_default = true,
        nerd_font_variant = 'mono'
      },
    },
    opts_extend = { "sources.default" }
  }
}


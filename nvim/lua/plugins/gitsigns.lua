return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    on_attach = function(bufnr)
      local gs = package.loaded.gitsigns

      local function map(mode, l, r, desc)
        vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
      end

      -- Navigation between modified hunks
      map("n", "]c", function()
        if vim.wo.diff then return "]c" end
        vim.schedule(function() gs.next_hunk() end)
        return "<Ignore>"
      end, "Next Git hunk")

      map("n", "[c", function()
        if vim.wo.diff then return "[c" end
        vim.schedule(function() gs.prev_hunk() end)
        return "<Ignore>"
      end, "Previous Git hunk")

      -- Preview, stage, reset, and diff hunks
      map("n", "<leader>hp", gs.preview_hunk, "Preview Git hunk")
      map("n", "<leader>hs", gs.stage_hunk, "Stage Git hunk")
      map("n", "<leader>hr", gs.reset_hunk, "Reset Git hunk")
      map("n", "<leader>hd", gs.diffthis, "Diff file against index")
    end,
  },
}


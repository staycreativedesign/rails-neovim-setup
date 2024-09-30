return {
  {
    "tpope/vim-fugitive"
  },
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require('gitsigns').setup()
      vim.keymap.set('n', '<leader>gx', ":Gitsigns preview_hunk<CR>", {})
      vim.keymap.set('n', '<leader>gb', ":Gitsigns toggle_current_line_blame<CR>", {})
    end
  }
}

return {
  {
    "datsfilipe/vesper.nvim",
    name = "vesper",
    priority = 1000, -- load before other UI plugins
    config = function()
      vim.cmd("colorscheme vesper")
    end,
  },
}


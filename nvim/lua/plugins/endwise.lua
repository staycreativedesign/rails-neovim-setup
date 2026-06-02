return {
  "RRethy/nvim-treesitter-endwise",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  event = "InsertEnter",
  config = function()
    require("nvim-treesitter.configs").setup({
      endwise = { enable = true },
    })
  end,
}

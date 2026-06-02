return {
  {
    "tpope/vim-rails",
    lazy = false,
    dependencies = {
      "tpope/vim-bundler",
      "tpope/vim-rake",
      "tpope/vim-dispatch",
      "tpope/vim-projectionist",
      "tpope/vim-endwise",
      "tpope/vim-surround",
      "tpope/vim-fugitive",
    },
    keys = {
      { "<leader>ra", "<cmd>A<cr>", desc = "Rails alternate file" },
      { "<leader>rr", "<cmd>R<cr>", desc = "Rails related file" },

      { "<leader>rm", ":Emodel ", desc = "Rails model" },
      { "<leader>rc", ":Econtroller ", desc = "Rails controller" },
      { "<leader>rv", ":Eview ", desc = "Rails view" },
      { "<leader>rh", ":Ehelper ", desc = "Rails helper" },
      { "<leader>rj", ":Ejob ", desc = "Rails job" },
      { "<leader>rt", ":Etest ", desc = "Rails test" },
      { "<leader>rs", ":Eschema<cr>", desc = "Rails schema" },
      { "<leader>rg", ":Econfig ", desc = "Rails config" },
    },
  },
}

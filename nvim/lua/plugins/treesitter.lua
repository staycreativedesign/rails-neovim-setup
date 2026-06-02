return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    dependencies = {
      "HiPhish/nvim-ts-rainbow2", -- Required for extended rainbow mode
    },
    config = function()
      local config = require("nvim-treesitter.configs")

      config.setup({
        rainbow = {
          enable = true,
          extended_mode = true,    -- Highlight brackets, parentheses, tags, etc.
          max_file_lines = 3000,   -- Disable for massive files
        },

        auto_install = true,
        endwise = { enabled = true },
        highlight = { enable = true },
        indent = { enable = true },
        ensure_installed = { "javascript", "lua", "ruby" },
      })

      --------------------------------------------------
      -- CUSTOM RAINBOW COLORS (vibrant, high contrast)
      --------------------------------------------------
      local hl = vim.api.nvim_set_hl

      -- Rainbow 2 highlight groups
      hl(0, "TSRainbowRed",    { fg = "#FF5F5F" }) -- bright red
      hl(0, "TSRainbowYellow", { fg = "#FFD75F" }) -- gold
      hl(0, "TSRainbowBlue",   { fg = "#5FAFFF" }) -- bright blue
      hl(0, "TSRainbowOrange", { fg = "#FF875F" }) -- neon orange
      hl(0, "TSRainbowGreen",  { fg = "#5FFF87" }) -- neon green
      hl(0, "TSRainbowViolet", { fg = "#AF5FFF" }) -- purple
      hl(0, "TSRainbowCyan",   { fg = "#5FFFFF" }) -- cyan
    end,
  },
}

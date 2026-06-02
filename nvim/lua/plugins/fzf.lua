return {
  {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" }, -- optional for icons
    config = function()
      local fzf = require("fzf-lua")

      fzf.setup({
        files = {
          prompt = "Files❯ ",
          git_icons = true,
          file_icons = true,
          color_icons = true,
          fd_opts = "--color=never --type f  --follow --exclude .kamal",
        },
        grep = {
          prompt = "Grep❯ ",
        },
      })

      -- Keybindings
      vim.keymap.set("n", "<leader>ff", fzf.files, {})
      vim.keymap.set("n", "<C-p>", fzf.git_files, {})
      vim.keymap.set("n", "<leader>fg", fzf.live_grep, {})
      vim.keymap.set("n", "<leader><leader>", fzf.oldfiles, {})
    end,
  },
}

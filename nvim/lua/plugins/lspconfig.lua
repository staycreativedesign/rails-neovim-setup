-- ~/.config/nvim/lua/plugins/lspconfig.lua
-- Ruby / Rails LSP setup using Mason + new vim.lsp.config API (Neovim 0.11+).

return {
  ---------------------------------------------------------------------------
  -- Mason: installs LSP servers
  ---------------------------------------------------------------------------
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    config = function()
      require("mason").setup()
    end,
  },

  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "neovim/nvim-lspconfig", -- provides built-in server definitions
    },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "ruby_lsp",
        },
        automatic_installation = true,
      })
    end,
  },

  ---------------------------------------------------------------------------
  -- Core LSP + Ruby LSP
  ---------------------------------------------------------------------------
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      -- Optional, but recommended if you're using nvim-cmp
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      -----------------------------------------------------------------------
      -- Capabilities (completion, etc.)
      -----------------------------------------------------------------------
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      local ok_cmp, cmp_nvim_lsp = pcall(require, "cmp-nvim-lsp")
      if ok_cmp then
        capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
      end

      -- Global defaults for ALL LSP configs
      vim.lsp.config("*", {
        capabilities = capabilities,
        root_markers = { ".git" },
      })

      -----------------------------------------------------------------------
      -- Diagnostics UI
      -----------------------------------------------------------------------
      vim.diagnostic.config({
        virtual_text = true,
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
      })

      -----------------------------------------------------------------------
      -- LspAttach: set buffer-local keymaps once per buffer
      -----------------------------------------------------------------------
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspKeymaps", { clear = true }),
        callback = function(args)
          local bufnr = args.buf
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if not client then
            return
          end

          local map = function(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, {
              buffer = bufnr,
              silent = true,
              desc = desc,
            })
          end

          -- Navigation
          map("n", "gd", vim.lsp.buf.definition, "Goto definition")
          map("n", "gD", vim.lsp.buf.declaration, "Goto declaration")
          map("n", "gr", vim.lsp.buf.references, "Goto references")
          map("n", "gi", vim.lsp.buf.implementation, "Goto implementation")

          -- Info / diagnostics
          map("n", "K", vim.lsp.buf.hover, "Hover")
          map("n", "<leader>sd", vim.diagnostic.open_float, "Line diagnostics")
          map("n", "[d", vim.diagnostic.goto_prev, "Prev diagnostic")
          map("n", "]d", vim.diagnostic.goto_next, "Next diagnostic")

          -- Refactors
          map("n", "<leader>rn", vim.lsp.buf.rename, "Rename symbol")
          map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "Code action")

          -- Formatting
          map("n", "<leader>f", function()
            vim.lsp.buf.format({ async = false })
          end, "Format buffer")
        end,
      })

      -----------------------------------------------------------------------
      -- Ruby on Rails: Ruby LSP config (new API)
      -----------------------------------------------------------------------
      -- nvim-lspconfig ships a builtin "ruby_lsp" definition.
      -- We override / extend it with vim.lsp.config.
      -- vim.lsp.config("ruby_lsp", {
      --   -- Prefer the project gem via Bundler.
      --   -- If ruby-lsp is NOT in your Gemfile, change to { "ruby-lsp" }.
      --   cmd = { "bundle", "exec", "ruby-lsp" },
      --
      --   -- If you want extra settings like Standard/RuboCop/Rails addon:
      --   --
      --   -- init_options = {
      --   --   formatter = "standard", -- or "rubocop"
      --   --   linters = { "standard" },
      --   --   addonSettings = {
      --   --     ["Ruby LSP Rails"] = {
      --   --       enablePendingMigrationsPrompt = false,
      --   --     },
      --   --   },
      --   -- },
      -- })
      --
      -- -- Finally, enable Ruby LSP.
      -- -- It will auto-attach on Ruby/Rails files when opened.
      -- vim.lsp.enable("ruby_lsp")
    end,
  },
}

vim.g.mapleader = " "


local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "gwt",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end

function RTags()
  vim.cmd [[!ctags -f .tags --languages=ruby --exclude=.git -R .]]
end

vim.keymap.set("n", "rT", RTags)


function RenameFile()
  local old_name = vim.fn.expand("%")
  local new_name = vim.fn.input("New file name: ", vim.fn.expand("%"), "file")
  if new_name ~= "" and new_name ~= old_name then
    vim.cmd(":saveas " .. new_name)
    vim.cmd(":silent !rm " .. old_name)
    vim.cmd("redraw!")
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins")

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.rb",
  callback = function()
    vim.lsp.buf.format()
  end,
})

vim.cmd([[
  augroup BWCCreatlDir
  autocmd!
  autocmd BufWritePre * if expand("<afile>")!~#'^\w\+:/' && !isdirectory(expand("%:h")) | execute "silent! !mkdir -p ".shellescape(expand('%:h'), 1) | redraw! | endif
  augroup END
]])


vim.keymap.set('n', '<Leader>df', ':call confirm_and_delete_buffer()')
vim.g.python3_host_prog = "~/.config/nvim/pyenv/bin/python"

vim.opt.termguicolors = true
vim.opt.conceallevel = 2
vim.opt.ignorecase = true -- search case
vim.opt.smartcase = true -- search matters if capital letter
vim.opt.inccommand = "split" -- "for incsearch while sub
vim.opt.lazyredraw = true -- redraw for macros
vim.opt.number = true -- line number on
vim.opt.relativenumber = true -- relative line number on
vim.opt.termguicolors = true -- true colors term support
vim.opt.undofile = true -- undo even when it closes
vim.opt.scrolloff = 8 -- number of lines to always go down
vim.opt.signcolumn = "number"
vim.opt.colorcolumn = "99999" -- fix columns
vim.opt.mouse = "a" -- set mouse to be on
vim.opt.background = "dark"
-- vim.opt.cmdheight = 0 -- status line smaller
vim.opt.splitbelow = true -- split windows below
vim.opt.splitright = true -- split windows right
vim.opt.diffopt:append("linematch:50")
vim.opt.cursorline = true
vim.opt.cursorlineopt = "both"

vim.opt.showmode = false
vim.opt.synmaxcol = 500
vim.api.nvim_set_hl(0, "CursorLine", { bg = "#303030", underline = false })



-- Commonly mistyped commands
vim.api.nvim_create_user_command("Q", "q", {})
vim.api.nvim_create_user_command("Qa", "qa", {})
vim.api.nvim_create_user_command("Wq", "wq", {})

local t_opts = {silent = true}
vim.keymap.set("n", "<leader>rf", RenameFile, { desc = "Rename file" })
vim.keymap.set('n', '<Leader>dd', ":call delete(expand('%')) | bdelete!<CR>", t_opts)
vim.keymap.set('n', '<Leader>nh', ':nohl<CR>', t_opts)


-- vim.keymap.set('n', '<Leader>tt', ':ToggleTerm size=20 dir=~git_dir direction=tab name="term"<CR>', t_opts)
vim.keymap.set('n', '<Leader>ga', ':Gwrite<CR>')
vim.keymap.set('n', '<Leader>gc', ':Git commit<CR>', t_opts)
vim.keymap.set('n', '<Leader>gs', ':Git<CR>', t_opts)
vim.keymap.set('n', '<Leader>gp', ':Git push<CR>', t_opts)
vim.keymap.set('n', '<Leader>tn', ':tabNext<CR>', t_opts)
vim.keymap.set('n', '<Leader>tc', ':tabclose<CR>', t_opts)
vim.keymap.set('t', '<esc>'     , '<C-\\><C-N>', t_opts)

vim.keymap.set('n', '<Leader>=' , ':horizontal resize 60<CR>', t_opts)
vim.keymap.set('n', '<Leader>-' , ':horizontal resize 40<CR>', t_opts)

vim.keymap.set("n", "<leader>ph", ":Gitsigns preview_hunk<CR>", {})
vim.keymap.set("n", "<leader>sh", ":Gitsigns stage_hunk<CR>", {})
vim.keymap.set("n", "<leader>ush", ":Gitsigns undo_stage_hunk<CR>", {})
vim.keymap.set('n', '<Leader>gd', ':Gitsigns diffthis<CR>', t_opts)


vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")
vim.cmd("set clipboard=unnamedplus")
vim.cmd("set numberwidth=2")
vim.cmd("set splitbelow")
vim.cmd("set noswapfile")
vim.cmd("set splitright")
vim.cmd("set backspace=indent,eol,start")
vim.cmd("set smartindent")
vim.cmd("set smarttab")
vim.cmd("set autoindent")

vim.opt.tags = "./tags;,tags;,gem.tags;"
vim.opt.wildmenu = true
vim.opt.wildmode = "longest:full,full"

vim.api.nvim_set_hl(0, 'LineNrAbove', { fg='green' })
vim.api.nvim_set_hl(0, 'LineNr', { fg='yellow' })
vim.api.nvim_set_hl(0, 'LineNrBelow', { fg='magenta'})


local function camelize(s)
  -- foo_bar -> FooBar
  return (s:gsub("(%a)([%w_]*)", function(first, rest)
    return first:upper() .. rest
  end):gsub("_(%a)", function(c)
      return c:upper()
    end))
end

local function split_path(p)
  local t = {}
  for part in p:gmatch("[^/]+") do
    table.insert(t, part)
  end
  return t
end

local function is_empty_buffer(bufnr)
  if vim.api.nvim_buf_line_count(bufnr) ~= 1 then return false end
  return vim.api.nvim_buf_get_lines(bufnr, 0, 1, false)[1] == ""
end

local function insert_ruby_services_skeleton()
  local bufnr = vim.api.nvim_get_current_buf()
  if not is_empty_buffer(bufnr) then return end

  local fullpath = vim.fn.expand("%:p")
  -- match anything after app/services/ and ending in .rb
  local rel = fullpath:match("/app/services/(.+)%.rb$")
  if not rel then return end

  local parts = split_path(rel)
  if #parts == 0 then return end

  local filename = parts[#parts]:gsub("%.rb$", "")
  parts[#parts] = nil

  local modules = {}
  for _, p in ipairs(parts) do
    table.insert(modules, camelize(p))
  end

  local class_name = camelize(filename)

  local lines = {}
  local indent = ""

  for _, m in ipairs(modules) do
    table.insert(lines, indent .. "module " .. m)
    indent = indent .. "  "
  end

  table.insert(lines, indent .. "class " .. class_name)
  table.insert(lines, indent .. "end")

  for i = #modules, 1, -1 do
    indent = indent:sub(1, -3) -- remove two spaces
    table.insert(lines, indent .. "end")
  end

  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)

  -- optional: place cursor inside the class body (between class..end)
  -- (line index is 0-based for cursor API)
  local cursor_line = (#modules) + 1 -- line with "class ..."
  vim.api.nvim_win_set_cursor(0, { cursor_line + 1, (#modules * 2) }) -- inside class, indentation
end

vim.api.nvim_create_autocmd({ "BufNewFile" }, {
  pattern = { "*.rb" },
  callback = insert_ruby_services_skeleton,
})



vim.diagnostic.config({
  virtual_text = {
    prefix = "●",   -- what you see at end of line
    spacing = 2,
  },
  signs = true,      -- icons in the gutter
  underline = true,  -- underline the offending text
  update_in_insert = false,
  severity_sort = true,
})

return {
  "christoomey/vim-tmux-navigator", -- tmux & split window navigation
}

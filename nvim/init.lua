
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

local function confirm_and_delete_buffer()
  os.remove(vim.fn.expand "%")
  vim.api.nvim_buf_delete(0, { force = true })
end
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
-- vim.opt.cmdheight = 0 -- status line smaller
vim.opt.splitbelow = true -- split windows below
vim.opt.splitright = true -- split windows right
vim.opt.diffopt:append("linematch:50")
vim.opt.cursorline = true
vim.opt.cursorlineopt = "number"
vim.opt.showmode = false

-- Commonly mistyped commands
vim.api.nvim_create_user_command("Q", "q", {})
vim.api.nvim_create_user_command("Qa", "qa", {})
vim.api.nvim_create_user_command("Wq", "wq", {})

local t_opts = {silent = true}
vim.keymap.set("n", "<leader>rf", RenameFile, { desc = "Rename file" })
vim.keymap.set('n', '<Leader>df', ":call delete(expand('%')) | bdelete!<CR>", t_opts)
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

vim.keymap.set("n", "<leader>gx", ":Gitsigns preview_hunk<CR>", {})
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
vim.cmd("set nocursorline")
vim.opt.tags = '.tags'

return {
  "christoomey/vim-tmux-navigator", -- tmux & split window navigation
}



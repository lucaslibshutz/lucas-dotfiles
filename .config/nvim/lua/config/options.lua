-- Options loaded before lazy.nvim startup
-- Inherits LazyVim defaults: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua

local opt = vim.opt

-- Line numbers
opt.number = true
opt.relativenumber = false

-- Indentation
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.smartindent = true

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

-- Appearance
opt.termguicolors = true
opt.signcolumn = "yes"
opt.cursorline = true
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.colorcolumn = "100"
opt.conceallevel = 0 -- don't hide quotes in markdown/JSON

-- Splits
opt.splitbelow = true
opt.splitright = true

-- Files
opt.undofile = true
opt.swapfile = false
opt.backup = false

-- Completion
opt.pumheight = 10
opt.completeopt = "menuone,noinsert,noselect"
opt.updatetime = 250
opt.timeoutlen = 400

-- Folding (use treesitter)
opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()"
opt.foldlevel = 99

-- WSL: fix slow escape
opt.ttimeoutlen = 10

-- Disable some annoying defaults
opt.wrap = false
opt.exrc = true

-- Editor
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

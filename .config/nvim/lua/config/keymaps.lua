-- Keymaps (loaded on VeryLazy event)
-- LazyVim defaults: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- ── Better defaults ─────────────────────────────────────────────────────────
-- Keep cursor centered during search navigation
keymap("n", "n", "nzzzv", opts)
keymap("n", "N", "Nzzzv", opts)

-- Keep cursor centered when joining lines
keymap("n", "J", "mzJ`z", opts)

-- Better up/down on wrapped lines
keymap({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
keymap({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Select all
keymap("n", "<C-a>", "gg<S-v>G", opts)

-- Increment / decrement
keymap("n", "+", "<C-a>", opts)
keymap("n", "-", "<C-x>", opts)

-- ── Window management ────────────────────────────────────────────────────────
keymap("n", "ss", ":split<CR>", opts)
keymap("n", "sv", ":vsplit<CR>", opts)

keymap("n", "sh", "<C-w>h", opts)
keymap("n", "sj", "<C-w>j", opts)
keymap("n", "sk", "<C-w>k", opts)
keymap("n", "sl", "<C-w>l", opts)

keymap("n", "<C-w><left>",  "<C-w><", opts)
keymap("n", "<C-w><right>", "<C-w>>", opts)
keymap("n", "<C-w><up>",    "<C-w>+", opts)
keymap("n", "<C-w><down>",  "<C-w>-", opts)

-- ── Tab management ───────────────────────────────────────────────────────────
keymap("n", "te",      ":tabedit<CR>", opts)
keymap("n", "<tab>",   ":tabnext<CR>", opts)
keymap("n", "<s-tab>", ":tabprev<CR>", opts)

-- ── Visual mode ──────────────────────────────────────────────────────────────
-- Move selected lines up/down
keymap("v", "J", ":m '>+1<CR>gv=gv", opts)
keymap("v", "K", ":m '<-2<CR>gv=gv", opts)

-- Paste without yanking selection
keymap("v", "<leader>p", '"_dP', opts)

-- Yank to system clipboard
keymap({ "n", "v" }, "<leader>y", '"+y', { desc = "Yank to clipboard" })
keymap("n", "<leader>Y", '"+Y', { desc = "Yank line to clipboard" })

-- ── Diagnostics ──────────────────────────────────────────────────────────────
keymap("n", "[d", vim.diagnostic.goto_prev,  { desc = "Prev diagnostic" })
keymap("n", "]d", vim.diagnostic.goto_next,  { desc = "Next diagnostic" })
keymap("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Diagnostic float" })

-- ── Quickfix ─────────────────────────────────────────────────────────────────
keymap("n", "<leader>qo", "<cmd>copen<cr>",  { desc = "Open quickfix" })
keymap("n", "<leader>qn", "<cmd>cnext<cr>",  { desc = "Next quickfix" })
keymap("n", "<leader>qp", "<cmd>cprev<cr>",  { desc = "Prev quickfix" })

-- ── Misc ─────────────────────────────────────────────────────────────────────
-- Clear search highlight
keymap("n", "<Esc>", "<cmd>nohl<cr><Esc>", opts)

-- Better delete (don't yank to default register)
keymap({ "n", "v" }, "<leader>d", '"_d', { desc = "Delete without yank" })

-- Source current file (useful when editing lua configs)
keymap("n", "<leader>xs", "<cmd>source %<cr>", { desc = "Source current file" })

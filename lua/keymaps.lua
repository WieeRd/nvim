local map = vim.keymap.set

-- Esc alternative
map('i', "kj", "<Esc>")

-- set <leader> to space
vim.g.mapleader = ' '
map({'n', 'x'}, " ", "")

-- Scrolling
map('n', "<ScrollWheelUp>", "<C-y>")
map('n', "<ScrollWheelDown>", "<C-e>")

-- TODO: find better use of arrow keys
map('n', "<Up>", "<C-y>")  -- scrolling
map('n', "<Down>", "<C-e>")
map('n', "<Left>", "gt")  -- tab navigation
map('n', "<Right>", "gT")

-- Clear search highlights when redrawing screen with Ctrl+L
map('n', "<C-l>", "<Cmd>noh<CR><C-l>")
-- I keep using Ctrl+S unconsciously even when using vim
map('n', "<C-s>", ":w<CR>")

-- ALT + hjkl to resize windows
map('n', "<M-j>", "<Cmd>resize -1<CR>")
map('n', "<M-k>", "<Cmd>resize +1<CR>")
map('n', "<M-h>", "<Cmd>vertical resize -1<CR>")
map('n', "<M-l>", "<Cmd>vertical resize +1<CR>")

-- quit after saving current session and all files
-- TODO: local session shortcut
map('n', "<F2>", "<Cmd>mksession! ~/Session.vim <Bar> wqa<CR>")
-- continue where I left off
map('n', "<F3>", "<Cmd>source ~/Session.vim<CR><C-l>")

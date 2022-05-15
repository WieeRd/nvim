-- [[ keymaps: ':map' stuff ]] --
-- TODO: add 'desc' field to mappings
local map = vim.keymap.set

-- set <Leader> to <Space>
vim.g.mapleader = ' '
map({ 'n', 'x' }, " ", "")

-- Esc alternative
map('i', "kj", "<Esc>")

-- Clear search highlights when redrawing screen with Ctrl+L
map('n', "<C-l>", "<Cmd>noh<CR><C-l>")

-- I keep using Ctrl+S unconsciously even when using vim
map('n', "<C-s>", "<Cmd>silent write<CR>")

-- Delete without worrying about yanked content
map('n', "yp", [["0p]])  -- paste from yank register
map('n', "yd", [["0d]])  -- delete into yank register

-- ALT + hjkl : Resize window
map('n', "<M-j>", "<Cmd>resize -1<CR>")
map('n', "<M-k>", "<Cmd>resize +1<CR>")
map('n', "<M-h>", "<Cmd>vertical resize -1<CR>")
map('n', "<M-l>", "<Cmd>vertical resize +1<CR>")

-- Tab navigation
map('n', "]t", "gt")
map('n', "[t", "gT")
map('n', "<Leader>1", "1gt")
map('n', "<Leader>2", "2gt")
map('n', "<Leader>3", "3gt")
map('n', "<Leader>4", "4gt")

-- Make mouse wheel scroll page instead of moving cursor
map({ 'n', 'v' }, "<Up>", "<C-y>")
map({ 'n', 'v' }, "<Down>", "<C-e>")

-- TODO: Left/Right arrow keys
map('n', "<Left>", "gT")
map('n', "<Right>", "gt")

-- F1 ~ F12 : TODO
-- map('n', "<F1>", "<Cmd>so Session.vim<CR><C-l>")    -- local session (.)
-- map('n', "<F2>", "<Cmd>mks! Session.vim <Bar> wqa<CR>")
-- map('n', "<F3>", "<Cmd>so ~/Session.vim<CR><C-l>")  -- global session (~)
-- map('n', "<F4>", "<Cmd>mks! ~/Session.vim <Bar> wqa<CR>")
-- map('n', "<F5>", "<Cmd>write <Bar> edit<CR>")

-- Using FZF as temporary fuzzy finder
map('n', "<C-p>", "<Cmd>FZF<CR>")

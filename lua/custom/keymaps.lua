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

-- Clear search highlights and last executed command with <Esc>
map('n', "<Esc>", "<Esc><Cmd>noh <Bar> echo ''<CR>")

-- I keep using Ctrl+S unconsciously even when using vim
map('n', "<C-s>", "<Cmd>silent write<CR>")

-- Delete without worrying about yanked content
map('n', "yp", [["0p]])  -- paste from yank register
map('n', "yd", [["0d]])  -- delete into yank register

-- Resize window with Alt + hjkl
map({ 'n', 'o' }, "<M-j>", "<C-w>-")
map({ 'n', 'o' }, "<M-k>", "<C-w>+")
map({ 'n', 'o' }, "<M-h>", "<C-w><")
map({ 'n', 'o' }, "<M-l>", "<C-w>>")

-- Tab navigation
map({ 'n', 'o' }, "]t", "gt")
map({ 'n', 'o' }, "[t", "gT")

map('n', "<Leader>1", "1gt")
map('n', "<Leader>2", "2gt")
map('n', "<Leader>3", "3gt")
map('n', "<Leader>4", "4gt")

map('n', "<Leader>+", "<Cmd>tabnew<CR>")
map('n', "<Leader>-", "<Cmd>tabclose<CR>")

-- Make mouse wheel scroll page instead of moving cursor
map({ 'n', 'v' }, "<Up>", "<C-y>")
map({ 'n', 'v' }, "<Down>", "<C-e>")

-- TODO: Left/Right arrow keys
-- map({ 'n', 'o' }, "<Left>", "gT")
-- map({ 'n', 'o' }, "<Right>", "gt")

-- TODO: F1 ~ F12
-- map('n', "<F1>", "<Cmd>so Session.vim<CR><C-l>")    -- local session (.)
-- map('n', "<F2>", "<Cmd>mks! Session.vim <Bar> wqa<CR>")
-- map('n', "<F3>", "<Cmd>so ~/Session.vim<CR><C-l>")  -- global session (~)
-- map('n', "<F4>", "<Cmd>mks! ~/Session.vim <Bar> wqa<CR>")
-- map('n', "<F5>", "<Cmd>write <Bar> edit<CR>")

-- Using FZF as temporary fuzzy finder
map('n', "<C-p>", "<Cmd>FZF<CR>")

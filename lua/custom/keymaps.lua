-- [[ keymaps: ':map' stuff ]] --
local map = vim.keymap.set
-- TODO: add 'desc' field to mappings

-- Esc alternative
map('i', "kj", "<Esc>")

-- set <leader> to <Space>
vim.g.mapleader = ' '
map({'n', 'x'}, " ", "")

-- [[ Mouse Wheel : Scrolling ]]
map('n', "<ScrollWheelUp>", "<C-y>")
map('n', "<ScrollWheelDown>", "<C-e>")

-- [[ Arrow Keys : Scrolling ]]
map('n', "<Up>", "<C-y>")
map('n', "<Down>", "<C-e>")

-- [[ Arrow Keys : Tab navigation ]]
map('n', "<Left>", "gT")
map('n', "<Right>", "gt")

-- [[ ALT + hjkl : Resize window ]]
map('n', "<M-j>", "<Cmd>resize -1<CR>")
map('n', "<M-k>", "<Cmd>resize +1<CR>")
map('n', "<M-h>", "<Cmd>vertical resize -1<CR>")
map('n', "<M-l>", "<Cmd>vertical resize +1<CR>")

-- [[ F1 ~ F4 : Manage Sessions ]]
map('n', "<F1>", "<Cmd>so Session.vim<CR><C-l>")    -- local session (.)
map('n', "<F2>", "<Cmd>mks! Session.vim <Bar> wqa<CR>")
map('n', "<F3>", "<Cmd>so ~/Session.vim<CR><C-l>")  -- global session (~)
map('n', "<F4>", "<Cmd>mks! ~/Session.vim <Bar> wqa<CR>")

-- F5 : reload buffer `:w | e`
map('n', "<F5>", "<Cmd>write <Bar> edit<CR>")

-- Clear search highlights when redrawing screen with Ctrl+L
map('n', "<C-l>", "<Cmd>noh<CR><C-l>")

-- I keep using Ctrl+S unconsciously even when using vim
map('n', "<C-s>", "<Cmd>silent write<CR>")

-- FZF instead of CtrlP
map('n', "<C-p>", "<Cmd>FZF<CR>")

-- Navigate tab pages
map('n', "]t", "gt")
map('n', "[t", "gT")

-- TODO: 'yp' mapping for yank register
-- TODO: 'yd' mapping for 'cut'

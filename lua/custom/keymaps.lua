-- [[ keymaps: ':map' stuff ]] --
local map = vim.keymap.set

-- set <Leader> to <Space>
vim.g.mapleader = ' '
map({ 'n', 'x' }, " ", "")

-- Esc alternative
map('i', "kj", "<Esc>")

-- Clear search highlights and last executed command with <Esc>
map('n', "<Esc>", "<Esc><Cmd>noh <Bar> echo ''<CR>")

-- I keep using Ctrl+S unconsciously even when using vim
map('n', "<C-s>", function()
  vim.notify(
    "Use <Leader>w instead!",
    vim.log.levels.WARN,
    { title = "keymaps.lua" }
  )
end)

-- Frequently used commands
map('n', "<Leader>w", "<Cmd>silent write<CR>")
map('n', "<Leader>W", "<Cmd>silent wall<CR>")

map('n', "<Leader>q", "<Cmd>quit<CR>")
map('n', "<Leader>Q", "<Cmd>quit!<CR>")  -- ZQ

map('n', "<Leader>e", "<Cmd>exit<CR>")  -- ZZ
map('n', "<Leader>E", "<Cmd>xall<CR>")

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
map({ 'n', 'o' }, "<Right>", "gt")
map({ 'n', 'o' }, "<Left>", "gT")

map('n', "]T", "<Cmd>tabmove +1<CR>")
map('n', "[T", "<Cmd>tabmove -1<CR>")

map('n', "<Leader>1", "1gt")
map('n', "<Leader>2", "2gt")
map('n', "<Leader>3", "3gt")
map('n', "<Leader>4", "4gt")

map('n', "<Leader>+", "<Cmd>tabnew<CR>")
map('n', "<Leader>-", "<Cmd>tabclose<CR>")
map('n', "<Leader>0", "<Cmd>tabonly<CR>")

-- Make mouse wheel scroll page instead of moving cursor
map({ 'n', 'v' }, "<Up>", "<C-y>")
map({ 'n', 'v' }, "<Down>", "<C-e>")

-- Using FZF as temporary fuzzy finder
map('n', "<C-p>", "<Cmd>FZF<CR>")


-- TODO: add 'desc' field to mappings
-- TODO: toggle boolean value (true, false)
-- TODO: unimpaired.vim bindings in Lua
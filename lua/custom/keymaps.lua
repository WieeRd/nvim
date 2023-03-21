-- [[ keymaps: ':map' stuff ]] --
local map = vim.keymap.set

-- <Space> as a <Leader> key
vim.g.mapleader = " "
map({ "n", "x" }, " ", "")

-- Esc alternative
map("i", "kj", "<Esc>")

-- Clear search highlights and last executed command with <Esc>
map("n", "<Esc>", "<Esc><Cmd>noh <Bar> echo ''<CR>")

-- Frequently used commands
map("n", "<Leader>w", "<Cmd>silent write<CR>")
map("n", "<Leader>W", "<Cmd>silent wall<CR>")
map("n", "<Leader>q", "<Cmd>quit<CR>")
map("n", "<Leader>Q", "<Cmd>quit!<CR>")

-- Open cmdline window with `:lua =` prefilled
map("n", "<Leader>:", ":lua =<C-f>a")

-- I hate magic
map("n", "/", "/\\V")  -- very nomagic
map("n", "?", "?\\V")  -- very nomagic

-- I like very magic
map("n", "g/", "/\\v")  -- very magic
map("n", "g?", "?\\v")  -- very magic

-- Delete without worrying about yanked content
map({ "n", "v" }, "yp", [["0p]])  -- paste from yank register
map({ "n", "v" }, "yd", [["0d]])  -- delete into yank register

-- Windows navigation
-- map("n", "<Leader>w", "<C-w>", { remap = true })

-- Tab navigation
map({ "n", "o" }, "]t", "gt")
map({ "n", "o" }, "[t", "gT")
map({ "n", "o" }, "<Right>", "gt")
map({ "n", "o" }, "<Left>", "gT")

map("n", "]T", "<Cmd>tabmove +1<CR>")
map("n", "[T", "<Cmd>tabmove -1<CR>")

map("n", "<Leader>1", "1gt")
map("n", "<Leader>2", "2gt")
map("n", "<Leader>3", "3gt")
map("n", "<Leader>4", "4gt")

map("n", "<Leader>+", "<Cmd>tabnew<CR>")
map("n", "<Leader>-", "<Cmd>tabclose<CR>")
map("n", "<Leader>0", "<Cmd>tabonly<CR>")

-- Make mouse wheel scroll page instead of moving cursor
map({ "n", "v" }, "<Up>", "<C-y>")
map({ "n", "v" }, "<Down>", "<C-e>")

-- 'entire buffer' text object
map({ "o", "v" }, "ae", function()
  vim.cmd("norm! m'vV")
  vim.cmd("keepjumps 0")
  vim.cmd("norm! o")
  vim.cmd("keepjumps $")
end)

-- `.` and `,` as word text objects
map({ "o", "v" }, ".", "iw")
map({ "o", "v" }, ",", "aW")

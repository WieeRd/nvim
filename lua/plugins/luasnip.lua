local ls = require("luasnip")
local map = vim.keymap.set

-- TODO: lsp_signature covering the screen
map({ 'i', 's' }, "<C-h>", function() ls.jump(-1) end)
map({ 'i', 's' }, "<C-l>", ls.expand_or_jump)  -- TODO: change to normal mode

require("luasnip.loaders.from_vscode").lazy_load()

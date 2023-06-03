local vim = vim

-- disable ShaDa while sourcing config
vim.o.shadafile = "NONE"

require("custom.options")
require("custom.keymaps")
require("custom.commands")
require("custom.autocmds")

if require("custom.plugins") then
  vim.cmd.colorscheme("kanagawa")
else
  vim.cmd.colorscheme("habamax")
end

-- re-enable ShaDa
vim.o.shadafile = ""

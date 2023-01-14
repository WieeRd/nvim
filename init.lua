local vim = vim

-- disable ShaDa while sourcing config
vim.o.shadafile = "NONE"


-- load custom settings
require("custom.globals")
require("custom.options")
require("custom.keymaps")
require("custom.commands")
require("custom.autocmds")

-- load plugin settings
require("plugins")

-- set colorscheme
vim.cmd.colorscheme("kanagawa")

-- re-enable ShaDa
vim.o.shadafile = ""

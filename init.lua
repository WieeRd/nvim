local vim = vim

-- disable shada while sourcing config
vim.o.shadafile = "NONE"

-- ultimately aiming for portable config
if not vim.env.dotvim then
  -- always '~/.config/nvim'
  -- vim.env.dotvim = fn.stdpath("config")

  -- where init.lua is located
  vim.env.dotvim = vim.fn.expand("<sfile>:h:p")
end

pcall(require, "impatient")
require("custom.globals")
require("custom.options")
require("custom.keymaps")
require("custom.commands")
require("custom.autocmds")

vim.api.nvim_create_user_command(
  "PackerSync",
  function()
    require("plugins")
    vim.cmd("PackerSync")
  end,
  {}
)

vim.cmd.colorscheme("kanagawa")

vim.o.shadafile = ""

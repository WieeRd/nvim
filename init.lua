local vim = vim

-- disable shada while sourcing config
vim.opt.shadafile = "NONE"

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

local g = vim.g
g.tokyonight_style = "night"
g.tokyonight_italic_keywords = false
g.tokyonight_dark_float = true
g.tokyonight_lualine_bold = true
vim.cmd("colorscheme tokyonight")

vim.opt.shadafile = ""

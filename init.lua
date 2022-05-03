local vim = vim

-- env.dotvim = fn.stdpath("config")  -- always '~/.config/nvim'
if not vim.env.dotvim then
  vim.env.dotvim = vim.fn.expand("<sfile>:h:p")  -- where init.lua is located
end

require("globals")
require("options")
require("keymaps")

vim.api.nvim_create_user_command(
  "PackerSync",
  function()
    require("plugins")
    vim.cmd("PackerSync")
  end,
  {}
)

vim.api.nvim_create_user_command(
  "PackerReset",
  "luafile $dotvim/lua/plugins.lua",
  {}
)

vim.cmd("colorscheme sonokai")

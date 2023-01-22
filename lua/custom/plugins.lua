local vim = vim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- bootstrap lazy.nvim
if not vim.loop.fs_stat(lazypath) then
  local answer = vim.fn.input("Would you like to setup plugins? [y/N] ")
  if answer == "y" then
    vim.notify("\nWorking on updates 42%\nDo not turn off your Neovim.\nThis will take a while.")
    vim.fn.system({
      "git",
      "clone",
      "--filter=blob:none",
      "https://github.com/folke/lazy.nvim",
      lazypath,
    })
  else
    vim.notify("Continuing without plugins.")
    return
  end
end

-- lazy.nvim config
vim.opt.runtimepath:prepend(lazypath)
require("lazy").setup("plugins")

local vim = vim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- bootstrap lazy.nvim
if not vim.loop.fs_stat(lazypath) then
  local answer = vim.fn.input({
    prompt = "Would you like to setup plugins? [y/N] ",
  })

  if answer == "y" then
    vim.notify(
      "\nWorking on updates 42%\nDo not turn off your Neovim.\nThis will take a while.",
      vim.log.levels.WARN
    )
    vim.fn.system({
      "git",
      "clone",
      "--filter=blob:none",
      "https://github.com/folke/lazy.nvim",
      lazypath,
    })
  else
    vim.notify("Continuing without plugins.", vim.log.levels.WARN)
    return false
  end
end

-- configure lazy.nvim
vim.opt.runtimepath:prepend(lazypath)
require("lazy").setup("plugins", {
  git = {
    log = { "-10", "--since=7 days ago" },
  },

  dev = {
    path = "~/Code",
    patterns = { --[[ "WieeRd" ]]
    },
  },

  install = {
    missing = true,
    colorscheme = { "habamax" },
  },

  ui = {
    custom_keys = {
      ["<localleader>l"] = false,
      ["<localleader>t"] = false,
    },
  },

  change_detection = {
    enabled = true,
    notify = false,
  },

  performance = {
    rtp = {
      reset = true,
      paths = {},
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})

return true

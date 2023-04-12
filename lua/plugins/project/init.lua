local config = require(... .. ".conf")
local function get_config(plugin, opts)
  return config[plugin.name](plugin, opts)
end

return {
  -- automatically cd to project root
  {
    "notjedi/nvim-rooter.lua",
    config = get_config,
  },

  -- `$ git` wrapped as `:G`, interactable git index
  {
    "tpope/vim-fugitive",
    event = "User InGitRepo",
    config = get_config,
  },

  -- preview and manipulate hunks
  {
    "lewis6991/gitsigns.nvim",
    event = "User InGitRepo",
    config = get_config,
  },

  -- nice overview of `git diff` and `git log`
  {
    "sindrets/diffview.nvim",
    event = "User InGitRepo",
    config = get_config,
  },

  -- auto save & load sessions
  {
    "rmagatti/auto-session",
    event = "VimEnter",
    config = get_config,
  },

  -- NOTE: auto-session & session-lens are being merged together (#161)
  -- search & load saved sessions using telescope.nvim
  {
    "rmagatti/session-lens",
    keys = {
      { "<Leader>fp", "<Cmd>SearchSession<CR>" },
    },
    dependencies = {
      "nvim-telescope/telescope.nvim",
    },
    config = get_config,
  },
}

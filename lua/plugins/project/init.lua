local config = require(... .. ".conf")
local function get_config(plugin, opts)
  return config[plugin.name](plugin, opts)
end

return {
  -- automatically cd to project root (detects .git)
  {
    "airblade/vim-rooter",
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
}

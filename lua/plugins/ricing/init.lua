local config = require(... .. ".conf")
local function get_config(plugin, opts)
  return config[plugin.name](plugin, opts)
end

return {
  -- indentation guide
  {
    "lukas-reineke/indent-blankline.nvim",
    config = get_config,
  },

  -- highlight references of the symbol under the cursor
  {
    "RRethy/vim-illuminate",
    config = get_config,
    enabled = false,
  },

  -- smooth scrolling
  {
    "karb94/neoscroll.nvim",
    keys = { "<C-u>", "<C-d>", "<C-b>", "<C-f>", "z" },
    config = get_config,
  },

  -- fancy folding powered by LSP/TS
  {
    "kevinhwang91/nvim-ufo",
    dependencies = "kevinhwang91/promise-async",
    config = get_config,
  },

  -- distraction free mode
  {
    "folke/zen-mode.nvim",
    keys = "<Leader>z",
    dependencies = "folke/twilight.nvim",
    config = get_config,
  },

  -- custom statusline & tabline
  {
    "rebelot/heirline.nvim",
    event = "UIEnter",
    dependencies = {
      "stevearc/aerial.nvim",
    },
    config = get_config,
  },

  -- WieeRd's favorite theme throughout the years
  { "nanotech/jellybeans.vim", lazy = true }, -- 2019
  { "dracula/vim", name = "dracula", lazy = true }, -- 2020
  { "sainnhe/sonokai", lazy = true }, -- 2021
  { "folke/tokyonight.nvim", lazy = true }, -- 2022
  { "rebelot/kanagawa.nvim", lazy = false, config = get_config }, -- 2023*

  -- next year candidates
  -- { "nyoom-engineering/oxocarbon.nvim", lazy = true },
  -- { "Yazeed1s/minimal.nvim", lazy = true },
  -- { "marko-cerovac/material.nvim", lazy = true },
  -- { "olimorris/onedarkpro.nvim", lazy = true },
  -- { "navarasu/onedark.nvim", lazy = true },
  -- { "tiagovla/tokyodark.nvim", lazy = true }
  -- { "vim-scripts/greenvision", lazy = true },
  { "rose-pine/neovim", name = "rose-pine", lazy = true },
  { "catppuccin/nvim", name = "catppuccin", lazy = true },
}

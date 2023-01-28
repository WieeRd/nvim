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
  },

  -- smooth scrolling
  {
    "karb94/neoscroll.nvim",
    keys = { "<C-u>", "<C-d>", "<C-b>", "<C-f>", "zt", "zz", "zb" },
    config = get_config,
  },

  -- fancy folding powered by LSP/TS
  {
    "kevinhwang91/nvim-ufo",
    dependencies = "kevinhwang91/promise-async",
    config = get_config,
  },

  -- TODO: statusline & tabline
  {
    -- "nvim-lualine/lualine.nvim",
    -- "feline-nvim/feline.nvim",
    -- "glepnir/galaxyline.nvim",
    -- "tjdevries/express_line.nvim",
  },

  -- distraction free mode
  {
    "folke/zen-mode.nvim",
    keys = "<Leader>z",
    dependencies = "folke/twilight.nvim",
    config = get_config,
  },

  -- WieeRd's favorite theme throughout the years
  { "nanotech/jellybeans.vim", lazy = true },        -- 2019
  { "dracula/vim", name = "dracula", lazy = true },  -- 2020
  { "sainnhe/sonokai", lazy = true },                -- 2021
  { "folke/tokyonight.nvim", lazy = true },          -- 2022
  { "rebelot/kanagawa.nvim", lazy = false },         -- 2023*

  -- trying out other themes
  -- "B4mbus/oxocarbon-lua.nvim",
  -- "vim-scripts/greenvision",
  -- "marko-cerovac/material.nvim",
  -- "olimorris/onedarkpro.nvim",
  -- "Yazeed1s/minimal.nvim",
}
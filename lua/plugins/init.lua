return {
  -- plugin manager itself
  { "folke/lazy.nvim" },

  -- useful lua functions
  { "nvim-lua/plenary.nvim" },

  -- filetype icons
  -- TODO: custom icon: help, man, fugitive
  { "kyazdani42/nvim-web-devicons" },

  -- profile startup time
  { "dstein64/vim-startuptime", cmd = "StartupTime" },

  -- keymap cheatsheet
  -- TODO: set all plugin mappings with this
  {
    "folke/which-key.nvim",
    config = function()
      require("which-key").setup({
        window = {
          -- top, right, bottom, left
          -- n > 1: absolute cell count
          -- n < 1: percentage of screen
          margin = { 1, 0.2, 1, 0.2 },
          padding = { 1, 2, 1, 2 },
        },
        layout = { align = "center" },
      })
    end,
  },
}

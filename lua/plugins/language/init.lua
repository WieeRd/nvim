return {
  -- live preview of rendered Markdown documents
  {
    "iamcco/markdown-preview.nvim",
    build = "cd app && yarn install",
    ft = "markdown",
  },

  -- nushell script
  {
    "LhKipp/nvim-nu",
    build = ":TSInstall nu",
    ft = "nu",
    config = function()
      require("nu").setup({})
    end,
  },

  -- KMonad's `.kbd` format support
  { "kmonad/kmonad-vim" },
}

return {
  -- live preview of rendered Markdown documents
  {
    "iamcco/markdown-preview.nvim",
    build = "cd app && yarn install",
    ft = "markdown",
    enabled = false,
  },

  -- Rust analyzer & codelldb DAP setup
  {
    "mrcjkb/rustaceanvim",
    version = "^4",
    ft = { "rust" },
  },

  -- nushell script
  {
    "LhKipp/nvim-nu",
    build = ":TSInstall nu",
    ft = "nu",
    config = function()
      require("nu").setup({})
    end,
    enabled = false,
  },

  -- KMonad's `.kbd` format support
  { "kmonad/kmonad-vim" },

  -- Direnv integration
  -- FEAT: direnv.nvim
  { "direnv/direnv.vim", enabled = false },
}

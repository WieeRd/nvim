return {
  -- portable package manager for neovim
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },

  -- setup LSP clients
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      -- "hrsh7th/cmp-nvim-lsp",
      "folke/neodev.nvim",
    },
    config = require("plugins.mason.lspconfig"),
  },

  -- TODO: setup DAP clients
  -- TODO: setup null-ls/formatters
}

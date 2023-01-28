local config = require(... .. ".conf")
local function get_config(plugin, opts)
  return config[plugin.name](plugin, opts)
end

return {
  -- portable package manager for neovim
  {
    "williamboman/mason.nvim",
    config = get_config,
  },

  -- setup LSP clients
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "folke/neodev.nvim",
      "barreiroleo/ltex_extra.nvim",
    },
    config = get_config,
  },

  -- TODO: setup DAP clients
  -- TODO: setup null-ls/formatters
}
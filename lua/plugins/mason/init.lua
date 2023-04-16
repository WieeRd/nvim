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

  -- setup linters and formatters
  {
    "jose-elias-alvarez/null-ls.nvim",
    dependencies = {
      "jay-babu/mason-null-ls.nvim",
    },
    config = get_config,
  },

  -- setup DAP clients
  {
    "mfussenegger/nvim-dap",
    keys = { "<Leader>d" },
    dependencies = {
      "jay-babu/mason-nvim-dap.nvim",
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
    },
    config = get_config,
  },
}

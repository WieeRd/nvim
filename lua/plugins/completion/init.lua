local config = require(... .. ".conf")
local function get_config(plugin, opts)
  return config[plugin.name](plugin, opts)
end

return {
  -- completion engine
  {
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      -- completion item icons
      "onsails/lspkind.nvim",
      -- completion sources
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "f3fora/cmp-spell",
      -- snippet expander
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
    config = get_config,
  },

  -- snippet engine
  {
    "L3MON4D3/LuaSnip",
    event = "InsertEnter",
    dependencies = {
      -- snippet collection
      "rafamadriz/friendly-snippets",
    },
    config = get_config,
  },

  -- generate annotations
  {
    "danymat/neogen",
    keys = "<Leader>n",
    dependencies = "LuaSnip",
    config = get_config,
  },

  -- show signature help in insert mode
  {
    "ray-x/lsp_signature.nvim",
    config = get_config,
  },
}

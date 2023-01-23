local config = require(... .. ".conf")
local function get_config(plugin, opts)
  return config[plugin.name](plugin, opts)
end

return {
  -- auto insert/remove closing pair
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = get_config,
  },

  -- manipulate surrounding pair
  {
    "kylechui/nvim-surround",
    keys = { "cs", "ds", "ys", { "S", mode = "v" } },
    config = get_config,
  },

  -- highlight and jump(%) between matching pair
  {
    "andymass/vim-matchup",
    config = get_config,
  },

  -- more and better around/inside text objects
  {
    "echasnovski/mini.ai",
    config = get_config,
  },

  -- comment out stuffs
  {
    "numToStr/Comment.nvim",
    keys = {
      { "gc", mode = { "n", "v" } },
      { "gb", mode = { "n", "v" } },
    },
    dependencies = "JoosepAlviste/nvim-ts-context-commentstring",
    config = get_config,
  },

  -- handy bracket[] mappings
  -- TODO: flexible Lua implementation
  {
    "tpope/vim-unimpaired",
    dependencies = "tpope/vim-repeat",
  },

  -- split/join multi-line statement
  -- TODO: indentions are weird after splitting in Lua
  {
    "Wansmer/treesj",
    keys = {
      { "gJ", "<Cmd>TSJJoin<CR>" },
      { "gS", "<Cmd>TSJSplit<CR>" },
    },
    config = get_config,
  },

  -- align code to a given character
  {
    "junegunn/vim-easy-align",
    keys = {
      { "ga", "<Plug>(EasyAlign)", mode = { "n", "v" } },
    },
  },

  -- 'sneak' mode; jump to anywhere on buffer
  {
    "phaazon/hop.nvim",
    keys = {
      { "<Leader>j", "<Cmd>HopWord<CR>", mode = { "n", "v" } },
    },
    config = get_config,
  },
}

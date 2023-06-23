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
    keys = { "cs", "ds", "ys", { "S", mode = "x" } },
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
      { "gc", mode = { "n", "x" } },
      { "gb", mode = { "n", "x" } },
    },
    dependencies = "JoosepAlviste/nvim-ts-context-commentstring",
    config = get_config,
  },

  -- handy bracket[] mappings
  -- TODO: flexible Lua implementation
  {
    "tpope/vim-unimpaired",
    dependencies = "tpope/vim-repeat",
    config = get_config,
    enabled = false,
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
      { "ga", "<Plug>(EasyAlign)", mode = { "n", "x" } },
    },
  },

  -- 'sneak' mode; jump to anywhere on buffer
  {
    "phaazon/hop.nvim",
    keys = {
      { "<Leader>j", "<Cmd>HopWordAC<CR>", mode = { "n", "x" } },
      { "<Leader>k", "<Cmd>HopWordBC<CR>", mode = { "n", "x" } },
    },
    config = get_config,
  },

  -- select treesitter syntax node
  {
    "mfussenegger/nvim-treehopper",
    keys = {
      {
        "<Leader>s",
        "<Cmd>lua require('tsht').nodes()<CR>",
        mode = { "n", "x", "o" },
      },
    },
  },
}

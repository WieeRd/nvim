return {
  -- treesitter integration and its modules
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = require("plugins.treesitter.conf"),
  },

  -- TS based auto indent
  { "yioneko/nvim-yati" },

  -- semantic motions & text objects
  { "nvim-treesitter/nvim-treesitter-textobjects" },

  -- smart text objects
  -- TODO: write more queries for Python & Lua
  { "RRethy/nvim-treesitter-textsubjects" },

  -- auto insert matching keyword (e.g. function/end in Lua)
  {
    "RRethy/nvim-treesitter-endwise",
    ft = { "ruby", "lua", "vim", "sh", "elixir" },
  },

  -- view & interact with TS syntax tree
  { "nvim-treesitter/playground", cmd = "TSPlaygroundToggle" },
}

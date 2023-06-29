local config = require(... .. ".conf")
local function get_config(plugin, opts)
  return config[plugin.name](plugin, opts)
end

return {
  -- find stuffs
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    cmd = "Telescope",
    keys = { "<C-p>", "<Leader>f" },
    dependencies = {
      -- fzf as fuzzy sort engine
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      -- use telescope as a select ui
      {
        "nvim-telescope/telescope-ui-select.nvim",
        init = function()
          ---@diagnostic disable-next-line: duplicate-set-field
          vim.ui.select = function(...)
            -- make lazy.nvim load Telescope
            require("telescope")
            vim.ui.select(...)
          end
        end,
      },
      -- search created sessions with session-lens
      { "rmagatti/auto-session" },
      -- view search results in a list
      { "folke/trouble.nvim" },
    },
    config = get_config,
  },

  -- list stuffs
  {
    "folke/trouble.nvim",
    keys = "<Leader>x",
    config = get_config,
  },

  -- find & highlight 'TODO' comments
  {
    "folke/todo-comments.nvim",
    -- has to be loaded on startup to highlight comments
    -- keys = { "<Leader>ft", "<Leader>xt" },
    dependencies = {
      -- "folke/trouble.nvim",
      -- "nvim-telescope/telescope.nvim",
    },
    config = get_config,
  },

  -- TUI file explorer
  {
    "luukvbaal/nnn.nvim",
    -- has to be loaded on startup to replace netrw
    -- keys = { "<C-n>", "g<C-n>" },
    config = get_config,
  },

  -- code outline (tree view of symbols)
  {
    "stevearc/aerial.nvim",
    -- required by statusline (heirline), no point in lazy-loading
    -- keys = "<Leader>a",
    config = get_config,
  },

  -- manage terminal windows
  {
    "akinsho/toggleterm.nvim",
    keys = "<S-Tab>",
    config = get_config,
  },

  -- extend features of `gx` keybind
  {
    "chrishrb/gx.nvim",
    config = true,
  },
}

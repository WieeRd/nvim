local config = require(... .. ".conf")
local function get_config(plugin, opts)
  return config[plugin.name](plugin, opts)
end

return {
  -- versatile fuzzy finder
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    cmd = "Telescope",
    keys = { "<Leader>f", "<C-p>" },
    dependencies = {
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      {
        "nvim-telescope/telescope-ui-select.nvim",
        init = function()
          ---@diagnostic disable-next-line: duplicate-set-field
          vim.ui.select = function(...)
            -- make lazy.nvim load Telescope
            require("telescope")
            vim.ui.select(...)
          end
        end
      },
    },
    config = get_config,
  },

  -- TUI file explorer
  {
    "luukvbaal/nnn.nvim",
    keys = "<C-n>",
    config = get_config,
  },

  -- list stuffs
  {
    "folke/trouble.nvim",
    keys = "<Leader>x",
    dependencies = {
      "folke/todo-comments.nvim"
    },
    config = get_config,
  },

  -- code outline (tree view of symbols)
  {
    "stevearc/aerial.nvim",
    keys = "<Leader>a",
    config = get_config,
  }
}

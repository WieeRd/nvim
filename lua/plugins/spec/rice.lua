return {
  -- indentation guide
  {
    "lukas-reineke/indent-blankline.nvim",
    config = function()
      require("indent_blankline").setup({
        char = '┊',
        context_char = '┊',
        show_current_context = true,
        show_current_context_start = false,
      })
    end
  },

  -- smooth scrolling
  {
    "karb94/neoscroll.nvim",
    keys = { "<C-u>", "<C-d>", "<C-b>", "<C-f>", "zt", "zz", "zb" },
    config = function()
      require("neoscroll").setup({
        mappings = { "<C-u>", "<C-d>", "<C-b>", "<C-f>", "zt", "zz", "zb" },
        hide_cursor = false,
        easing_function = "quadratic",
      })
    end
  },

  -- distraction free mode
  {
    -- "folke/zen-mode.nvim",
    "WieeRd/zen-mode.nvim",  -- until #78 gets merged
    cmd = "ZenMode",
    keys = "<Leader>z",
    dependencies = "folke/twilight.nvim",
    config = function()
      local zen = require("zen-mode")
      zen.setup()

      local center = {
        window = {
          backdrop = 0.85,
          width = 120,
          height = 1,
          options = {
            cursorline = true,
            relativenumber = false,
          },
        },
        plugins = {
          twilight = { enabled = false }
        },
      }

      local focus = {
        window = {
          backdrop = 1,
          width = 90,
          height = 1,
          options = {
            number = false,
            relativenumber = false,
          }
        },
        on_open = function(win)
          vim.wo.scrolloff = vim.fn.float2nr(vim.fn.winheight(win)*0.4)
          vim.cmd("silent! IndentBlanklineDisable")
        end,
        on_close = function(win)
          vim.cmd("silent! IndentBlanklineEnable")
        end
      }

      local map = vim.keymap.set
      map("n", "<Leader>zc", function() zen.toggle(center) end)
      map("n", "<Leader>zf", function() zen.toggle(focus) end)
      map("n", "<Leader>zt", "<Cmd>Twilight<CR>")
    end
  },

  -- TODO: statusline & tabline
  {
    -- "nvim-lualine/lualine.nvim",
    -- "feline-nvim/feline.nvim",
    -- "glepnir/galaxyline.nvim",
    -- "tjdevries/express_line.nvim",
  },

  -- WieeRd's favorite theme throughout the years
  { "nanotech/jellybeans.vim", lazy = true },        -- 2019
  { "dracula/vim", name = "dracula", lazy = true },  -- 2020
  { "sainnhe/sonokai", lazy = true },                -- 2021
  { "folke/tokyonight.nvim", lazy = true },          -- 2022
  { "rebelot/kanagawa.nvim", lazy = false },         -- 2023*

  -- trying out other themes
  -- "B4mbus/oxocarbon-lua.nvim",
  -- "vim-scripts/greenvision",
  -- "marko-cerovac/material.nvim",
  -- "olimorris/onedarkpro.nvim",
  -- "Yazeed1s/minimal.nvim",
}

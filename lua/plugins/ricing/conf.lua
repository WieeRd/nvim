local config = {}

config["indent-blankline.nvim"] = function()
  require("indent_blankline").setup({
    char = '┊',
    context_char = '┊',
    show_current_context = true,
    show_current_context_start = false,
  })
end

config["vim-illuminate"] = function()
  local illuminate = require("illuminate")

  illuminate.configure({
    providers = { "lsp", "treesitter" },
    delay = 10,
  })

  local map = vim.keymap.set
  map("n", "]r", illuminate.goto_next_reference)
  map("n", "[r", illuminate.goto_prev_reference)

  -- remove default keymaps
  map("n", "<A-n>", "")
  map("n", "<A-p>", "")
  map("n", "<A-i>", "")
end

config["neoscroll.nvim"] = function()
  require("neoscroll").setup({
    mappings = { "<C-u>", "<C-d>", "<C-b>", "<C-f>", "zt", "zz", "zb" },
    hide_cursor = false,
    easing_function = "quadratic",
  })
end

config["nvim-ufo"] = function()
  local ufo = require("ufo")
  -- TODO: custom virtual text handler
  ufo.setup()

  vim.o.foldlevel = 99
  vim.o.foldlevelstart = 99
  vim.o.foldenable = true

  local map = vim.keymap.set
  map("n", "zR", ufo.openAllFolds)
  map("n", "zM", ufo.closeAllFolds)
  map("n", "z[", ufo.goPreviousClosedFold)
  map("n", "z]", ufo.goNextClosedFold)
end

config["zen-mode.nvim"] = function()
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

return config

local vim = vim
local autocmd_id = nil

local center = {}
local read = {}
local focus = {
  window = {
    backdrop = 1,  -- shading amount
    width = 90,
    height = 0.95,

    -- vim.wo options applied to Zen window
    options = {
      signcolumn = "no",
      number = false,
      relativenumber = false,
      cursorline = false,
      cursorcolumn = false,
      foldcolumn = "0",
      list = false,
    },
  },

  plugins = {
    -- disable global vim options (vim.o...)
    options = {
      enabled = true,
      ruler = false,
      showcmd = false,
    },

    -- disable other plugins
    twilight = { enabled = true },
    gitsigns = { enabled = false },
    tmux = { enabled = false },  -- disables the tmux statusline
  },

  on_open = function(win)
    -- cursor will always remain at center 20% of the screen
    vim.wo.scrolloff = vim.fn.float2nr(vim.fn.winheight(win)*0.4)

    -- remove '~' in the line number column after EOF
    vim.opt.fillchars:append("eob: ")

    -- disable indentation indicator with buf-local options
    -- since 'IndentBlanklineDisable' is somehow not working
    vim.b.indent_blankline_char = ""
    vim.b.indent_blankline_context_char = ""
    vim.cmd("IndentBlanklineRefresh")

    -- automatically clear last executed command
    autocmd_id = vim.api.nvim_create_autocmd(
      "CmdlineLeave",
      { command = [[echo ""]] }
    )

    vim.cmd([[echo ""]])  -- clear `:ZenMode` left in cmdline
  end,

  on_close = function()
    vim.opt.fillchars:remove("eob")

    -- re-enable indentline by removing buf-local options
    vim.b.indent_blankline_char = nil
    vim.b.indent_blankline_context_char = nil
    vim.cmd("IndentBlanklineRefresh")

    vim.api.nvim_del_autocmd(autocmd_id)
  end,
}

local zen_mode = require("zen-mode")
zen_mode.setup(focus)

-- vim.keymap.set('n', "<Leader>zc", function() zen_mode.toggle(center) end)  -- 'Zen Center'
-- vim.keymap.set('n', "<Leader>zr", function() zen_mode.toggle(read) end)  -- 'Zen Read'
-- vim.keymap.set('n', "<Leader>zd", function() zen_mode.toggle(focus) end)  -- 'Zen Focus'

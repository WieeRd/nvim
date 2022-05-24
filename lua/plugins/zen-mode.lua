local vim = vim
local config = {}

-- minimal config that merely centers the window
config["center"] = {
  window = {
    backdrop = 0.85,  -- shading amount
    width = 120,
    height = 1,

    -- vim.wo options
    options = { cursorline = true },
  },

  plugins = {
    -- disable global vim options (vim.o...)
    options = {
      enabled = true,
      ruler = false,
      showcmd = false,
    },

    twilight = { enabled = false },
  },

  on_open = function(win)
    -- cursor will always remain at center 40% of the screen
    vim.wo.scrolloff = vim.fn.float2nr(vim.fn.winheight(win)*0.3)

    -- automatically clear last executed command
    vim.api.nvim_create_augroup("clearcmd", {})
    vim.api.nvim_create_autocmd(
      "CmdlineLeave",
      { group = "clearcmd", command = [[echo ""]] }
    )

    vim.cmd([[echo ""]])
  end,

  on_close = function()
    vim.api.nvim_del_augroup_by_name("clearcmd")
  end,
}


-- eliminate everything except the code itself
config["focus"] = {
  window = {
    backdrop = 1,  -- shading amount
    width = 90,
    height = 0.95,

    -- vim.wo options
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
    vim.wo.scrolloff = vim.fn.float2nr(vim.fn.winheight(win)*0.3)

    -- remove '~' in the line number column after EOF
    vim.opt.fillchars:append("eob: ")

    -- disable indentation indicator with buf-local options
    -- since 'IndentBlanklineDisable' is somehow not working
    vim.b.indent_blankline_char = ""
    vim.b.indent_blankline_context_char = ""
    vim.cmd("IndentBlanklineRefresh")

    -- automatically clear last executed command
    vim.api.nvim_create_augroup("clearcmd", {})
    vim.api.nvim_create_autocmd(
      "CmdlineLeave",
      { group = "clearcmd", command = [[echo ""]] }
    )

    vim.cmd([[echo ""]])
  end,

  on_close = function()
    vim.opt.fillchars:remove("eob")

    vim.b.indent_blankline_char = nil
    vim.b.indent_blankline_context_char = nil
    vim.cmd("IndentBlanklineRefresh")

    vim.api.nvim_del_augroup_by_name("clearcmd")
  end,
}


local zen_mode = require("zen-mode")

vim.keymap.set('n', "<Leader>zc", function()
  zen_mode.setup(config["center"])
  zen_mode.toggle()
end) 

vim.keymap.set('n', "<Leader>zf", function()
  zen_mode.setup(config["focus"])
  zen_mode.toggle()
end)  

vim.keymap.set('n', "<Leader>zt", "<Cmd>Twilight<CR>")
vim.keymap.set('n', "<Leader>zl", "<Cmd>Limelight!!<CR>")

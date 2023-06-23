return {
  {
    "ColorScheme",
    callback = function(args)
      vim.cmd.runtime("after/colors/default.vim") -- ran for every colorscheme
      vim.cmd.runtime(("after/colors/%s.vim"):format(args.match))
    end,
    desc = "override each colorscheme in `after/colors/*.vim`",
  },

  {
    "TermOpen",
    callback = function(_)
      local wo = vim.wo
      wo.winhl = "Normal:NormalFloat"
      wo.scrolloff = 0
      wo.number = false
      wo.relativenumber = false
    end,
    desc = "set terminal window options",
  },

  {
    "TextYankPost",
    callback = function(_)
      vim.highlight.on_yank({
        higroup = "CursorLine",
        timeout = 150,
        on_macro = false,
        on_visual = true,
      })
    end,
    desc = "briefly highlight the yanked text",
  },

  {
    "TabEnter",
    callback = function(_)
      local g = vim.g
      g.tabpage_prev = g.tabpage_curr
      g.tabpage_curr = vim.api.nvim_get_current_tabpage()
    end,
    desc = "remember last visited tabpage",
  },

  {
    "TabClosed",
    callback = function(_)
      local g, api = vim.g, vim.api
      if
        g.tabpage_curr ~= api.nvim_get_current_tabpage()
        and api.nvim_tabpage_is_valid(g.tabpage_prev)
      then
        api.nvim_set_current_tabpage(g.tabpage_prev)
      end
    end,
    desc = "go to last visited tab when current tab is closed",
  },

  {
    { "FocusGained", "TermClose", "TermLeave" },
    command = "checktime",
    desc = "check if any buffers were changed outside of Vim",
  },

  {
    "VimResized",
    command = "tabdo wincmd =",
    desc = "resize splits on window resize",
  },
}

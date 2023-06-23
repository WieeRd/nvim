return {
  {
    "ColorScheme",
    callback = function(args)
      vim.cmd.runtime("after/colors/default.vim") -- ran for every colorscheme
      vim.cmd.runtime(("after/colors/%s.vim"):format(args.match))
    end,
    desc = "override each colorscheme with `after/colors/*.vim`",
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
    desc = "set local options for the terminal buffers",
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

  -- FEAT: ASAP: smart float window background
  {
    "TabEnter",
    callback = function(_)
      -- vim.g.last_accessed_tab = vim.api.nvim_get_current_tabpage()
    end
  }
}

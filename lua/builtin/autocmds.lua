return {
  {
    "LspAttach",
    callback = function(args)
      local bufnr = args.buf
      -- local client = vim.lsp.get_client_by_id(args.data.client_id)

      local function map(mode, lhs, rhs, opt)
        opt = opt or {}
        opt.buffer = bufnr
        vim.keymap.set(mode, lhs, rhs, opt)
      end

      local function bind(func, opts)
        return function()
          func(opts)
        end
      end

      -- navigate diagnostics
      local dg = vim.diagnostic
      map("n", "[d", dg.goto_prev)
      map("n", "]d", dg.goto_next)
      map("n", "[D", bind(dg.goto_prev, { severity = dg.severity.WARN }))
      map("n", "]D", bind(dg.goto_next, { severity = dg.severity.WARN }))

      -- NOTE: 'list all' stuff keymaps -> trouble.nvim
      -- NOTE: lsp formatting keymaps -> null-ls.nvim

      -- goto definition
      map("n", "gd", vim.lsp.buf.definition)
      map("n", "gD", vim.lsp.buf.type_definition)

      -- call hierarchy
      map("n", "<Leader>li", vim.lsp.buf.incoming_calls)
      map("n", "<Leader>lo", vim.lsp.buf.outgoing_calls)

      -- actions
      map("n", "<Leader>lr", vim.lsp.buf.rename)
      map("n", "<Leader>la", vim.lsp.buf.code_action)

      -- show docs
      map("n", "K", vim.lsp.buf.hover) -- docs
      map("i", "<C-s>", vim.lsp.buf.signature_help) -- signature
    end,
  },

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
        and api.nvim_tabpage_is_valid(g.tabpage_prev or -1)
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

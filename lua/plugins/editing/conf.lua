local config = {}

config["nvim-autopairs"] = function()
  local npairs = require("nvim-autopairs")
  local Rule = require("nvim-autopairs.rule")

  npairs.setup({
    -- wrap things in insert mode
    fast_wrap = {
      map = "<A-w>",
      keys = "asdfghjkl;",
    },
    -- use treesitter to check closing pair
    check_ts = true,
  })

  -- custom rule: add spaces between parenthesis { | }
  npairs.add_rules({
    Rule(" ", " "):with_pair(function(opts)
      local pair = opts.line:sub(opts.col - 1, opts.col)
      return vim.tbl_contains({ "()", "[]", "{}" }, pair)
    end),
    Rule("( ", " )")
      :with_pair(function()
        return false
      end)
      :with_move(function(opts)
        return opts.prev_char:match(".%)") ~= nil
      end)
      :use_key(")"),
    Rule("{ ", " }")
      :with_pair(function()
        return false
      end)
      :with_move(function(opts)
        return opts.prev_char:match(".%}") ~= nil
      end)
      :use_key("}"),
    Rule("[ ", " ]")
      :with_pair(function()
        return false
      end)
      :with_move(function(opts)
        return opts.prev_char:match(".%]") ~= nil
      end)
      :use_key("]"),
  })
end

config["nvim-surround"] = function()
  require("nvim-surround").setup({
    keymaps = {
      change = "cs",
      delete = "ds",
      normal = "ys",
      normal_cur = "yss",
      visual = "S",
    },
  })
end

config["vim-matchup"] = function()
  vim.g.matchup_matchparen_offscreen = { method = "" }
end

config["mini.ai"] = function()
  require("mini.ai").setup()
end

config["Comment.nvim"] = function()
  vim.g.skip_ts_context_commentstring_module = true
  require("ts_context_commentstring").setup({
    enable_autocmd = false,
  })

  require("Comment").setup({
    pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
  })
end

config["vim-unimpaired"] = function()
  vim.keymap.del("n", "[xx")
  vim.keymap.del("n", "]xx")
end

config["treesj"] = function()
  require("treesj").setup({ use_default_keymaps = false })
end

config["hop.nvim"] = function()
  require("hop").setup()
end

return config

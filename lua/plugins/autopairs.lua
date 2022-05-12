local npairs = require("nvim-autopairs")
local Rule = require("nvim-autopairs.rule")

npairs.setup({
  fast_wrap = {},  -- <A-e> in insert mode
})

npairs.add_rules {  -- Add spaces between parenthesis
  Rule(" ", " ")
    :with_pair(
      function (opts)
        local pair = opts.line:sub(opts.col - 1, opts.col)
        return vim.tbl_contains({ "()", "[]", "{}" }, pair)
      end
    ),
  Rule("( ", " )")
    :with_pair(function() return false end)
    :with_move(
      function(opts)
        return opts.prev_char:match(".%)") ~= nil
      end
    )
    :use_key(")"),
  Rule("{ ", " }")
    :with_pair(function() return false end)
    :with_move(
      function(opts)
        return opts.prev_char:match(".%}") ~= nil
      end
    )
    :use_key("}"),
  Rule("[ ", " ]")
    :with_pair(function() return false end)
    :with_move(
      function(opts)
        return opts.prev_char:match(".%]") ~= nil
      end
    )
    :use_key("]")
}

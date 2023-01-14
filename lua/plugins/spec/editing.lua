return {
  -- auto insert/delete closing pair
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      local npairs = require("nvim-autopairs")
      local Rule = require("nvim-autopairs.rule")

      npairs.setup({
        -- wrap things in insert mode
        fast_wrap = {
          map = "<C-s>",
          keys = "asdfghjkl;",
        },
        -- use treesitter to check closing pair
        check_ts = true,
      })

      -- custom rule: add spaces between parenthesis { | }
      npairs.add_rules({
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
          :use_key("]"),
      })
    end
  },

  -- manipulate surrounding pair
  {
    "kylechui/nvim-surround",
    keys = { "ys", "cs", "ds", { "S", mode = "v" } },
    config = function()
      require("nvim-surround").setup()
    end
  },

  -- highlight and jump(%) between matching pairs/keywords
  {
    "andymass/vim-matchup",
    config = function()
      vim.g.matchup_matchparen_offscreen = { method = "" }
    end
  },

  -- more and better inside/around textobjects
  "wellle/targets.vim",

  -- comment out a section of code
  {
    "numToStr/Comment.nvim",
    keys = {
      { "gc", mode = { "n", "v" } },
      { "gb", mode = { "n", "v" } },
    },
    dependencies = "JoosepAlviste/nvim-ts-context-commentstring",
    config = function()
      require("Comment").setup({
        pre_hook = require(
          "ts_context_commentstring.integrations.comment_nvim"
        ).create_pre_hook(),
      })
    end
  },

  -- handy bracket[] mappings
  -- TODO: write lua based alternative
  {
    "tpope/vim-unimpaired",
    dependencies = "tpope/vim-repeat"
  },

  -- smart split/join multi-line statement
  -- TODO: indentions are weird after splitting
  {
    "Wansmer/treesj",
    keys = {
      { "gJ", "<Cmd>TSJJoin<CR>" },
      { "gS", "<Cmd>TSJSplit<CR>" },
    },
    config = function()
      require("treesj").setup({ use_default_keymaps = false })
    end,
  },

  -- align code to a given character
  {
    "junegunn/vim-easy-align",
    keys = { { "ga", "<Plug>(EasyAlign)", mode = { "n", "x" } } },
  },

  -- 'sneak' mode; jump to anywhere on buffer
  {
    "phaazon/hop.nvim",
    keys = { 
      { "<Leader>j", mode = { "n", "x" } },
      { "g/", mode = { "n", "x" } },
    },
    config = function()
      local hop = require("hop")
      hop.setup()
      vim.keymap.set({ "n", "x" }, "<Leader>j", hop.hint_words)  -- 'jump'
      vim.keymap.set({ "n", "x" }, "g/", hop.hint_patterns)  -- 'goto search'
    end
  },
}

require("nvim-treesitter.configs").setup({
  ensure_installed = {
    "bash",
    "c",
    "comment",
    "cpp",
    "lua",
    "python",
    "vim",
  },

  ignore_install = { "help" },

  highlight = {
    enable = true,
    disable = { "help" },
    additional_vim_regex_highlighting = false,
  },

  -- -- TODO: couldn't figure out proper keybinds
  -- incremental_selection = {
  --   enable = true,
  --   keymaps = {
  --     init_selection = "gn",
  --     scope_incremental = "gs",  -- 'grow scope'
  --     node_incremental = "gn",  -- 'grow node'
  --     node_decremental = "gN",
  --   },
  -- },

  indent = { enable = true },

  textobjects = {
    select = {
      enable = true,
      lookahead = true,
      keymaps = {
        -- would be nice it removes next whitespace too
        -- TODO: if/for textobjs
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["as"] = "@statement.outer",  -- TODO: doesn't work in lua, gotta PR
        ["a/"] = "@comment.outer",  -- TODO: doesn't include whitespace at the beginning
      },
    },
    move = {
      enable = true,
      set_jumps = true,
      goto_next_start = {
        ["]]"] = "@class.outer",
        ["]m"] = "@function.outer",
        ["]i"] = "@conditional.outer",
        ["]l"] = "@loop.outer",
      },
      goto_next_end = {
        ["]["] = "@class.outer",
        ["]M"] = "@function.outer",
        ["]I"] = "@conditional.outer",
        ["]L"] = "@loop.outer",
      },
      goto_previous_start = {
        ["[["] = "@class.outer",
        ["[m"] = "@function.outer",
        ["[i"] = "@conditional.outer",
        ["[l"] = "@loop.outer",
      },
      goto_previous_end = {
        ["[]"] = "@class.outer",
        ["[M"] = "@function.outer",
        ["[I"] = "@conditional.outer",
        ["[L"] = "@loop.outer",
      },
    },
  },

  playground = {
    enable = true
  },

  matchup = {
    enable = true,
    disable_virtual_text = true,
    include_match_words = true,
  },

  context_commentstring = {
    enable = true,
    enable_autocmd = false,
  },
})


local vim = vim

-- automatically TS fold every buffer
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldlevel = 999  -- all folds are opened by default

-- -- manually activate TS folding
-- vim.api.nvim_create_user_command(
--   "Fold",  -- could use "<Leader>tf" mapping instead of command
--   function()
--     if vim.wo.foldmethod ~= "expr" then
--       vim.wo.foldmethod = "expr"
--       vim.wo.foldexpr = "nvim_treesitter#foldexpr()"
--       vim.wo.foldlevel = 0
--     else
--       vim.wo.foldmethod = "manual"
--       vim.wo.foldlevel = 999  -- in case of javascript (9 won't be enough)
--     end
--   end,
--   {}
-- )

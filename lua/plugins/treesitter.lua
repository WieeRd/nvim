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

  highlight = {
    enable = true,
    disable = { "help" },  -- vimdoc highlight is very broken atm
    additional_vim_regex_highlighting = false,
  },

  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<Tab>",
      scope_incremental = "<Nop>",  -- 'grow scope'
      node_incremental = "<Tab>",  -- 'grow node'
      node_decremental = "<S-Tab>",
    },
  },

  indent = { enable = true },

  textsubjects = {
    enable = true,
    prev_selection = "<BS>", -- (Optional) keymap to select the previous selection
    keymaps = {
      ["<CR>"] = "textsubjects-smart",
      ["a<CR>"] = "textsubjects-container-outer",
      ["i<CR>"] = "textsubjects-container-inner",
    },
  },

  textobjects = {
    select = {
      enable = true,
      lookahead = true,
      keymaps = {
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ai"] = "@conditional.outer",
        ["ii"] = "@conditional.inner",
        ["al"] = "@loop.outer",
        ["il"] = "@loop.inner",

        -- will be removed when C/C++ support for textsubjects is merged (#19)
        ["as"] = "@statement.outer",
        -- TODO: delete comment EOL (#128)
        ["a/"] = "@comment.outer",
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

  endwise = { enable = true },

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



-- TODO: folds doesn't seem to get updated when buffer is edited
-- vim.cmd("set foldmethod=manual | set foldmethod=expr")
-- vim.keymap.set('n', "zc", "fold current context")

-- automatically TS fold every buffer
local opt = vim.opt
opt.foldexpr = "nvim_treesitter#foldexpr()"
-- opt.foldmethod = "expr"
-- opt.foldlevel = 999

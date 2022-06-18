require("nvim-treesitter.configs").setup({
  ensure_installed = {
    "bash",
    "comment",
    "lua",
  },

  highlight = {
    enable = true,
    disable = { "help", "vim" },
    additional_vim_regex_highlighting = false,
  },

  -- builtin indent module have some flaws
  indent = { enable = false },
  -- using yati instead while it gets fixed
  yati = { enable = true },

  -- TODO: send PR with queries for python & lua
  textsubjects = {
    enable = true,
    prev_selection = "<BS>",
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

        ["as"] = "@statement.outer",
        ["a/"] = "@comment.outer",  -- TODO: mapping for deleting comment EOL (#128)
      },
    },
    move = {
      enable = true,
      set_jumps = true,
      goto_next_start = {
        ["]]"] = "@class.outer",
        ["]m"] = "@function.outer",
        ["]i"] = "@conditional.outer",
        ["]w"] = "@loop.outer",
      },
      goto_next_end = {
        ["]["] = "@class.outer",
        ["]M"] = "@function.outer",
        ["]I"] = "@conditional.outer",
        ["]W"] = "@loop.outer",
      },
      goto_previous_start = {
        ["[["] = "@class.outer",
        ["[m"] = "@function.outer",
        ["[i"] = "@conditional.outer",
        ["[w"] = "@loop.outer",
      },
      goto_previous_end = {
        ["[]"] = "@class.outer",
        ["[M"] = "@function.outer",
        ["[I"] = "@conditional.outer",
        ["[W"] = "@loop.outer",
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


-- enable treesitter based folding by default
-- TODO: folds get out of sync sometimes when the buffer is edited
local opt = vim.opt
opt.foldexpr = "nvim_treesitter#foldexpr()"
opt.foldmethod = "expr"
opt.foldlevel = 999
opt.sessionoptions:remove("folds")

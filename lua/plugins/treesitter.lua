require("nvim-treesitter.configs").setup({
  ensure_installed = {
    "bash",
    "comment",
    "git_rebase",
    "gitcommit",
    "help",
    "lua",
  },
  auto_install = true,

  highlight = {
    enable = true,
    disable = function(lang, buf)
      -- fixes broken highlights inside cmdline window
      -- https://github.com/nvim-treesitter/nvim-treesitter/issues/3961
      if lang == "vim" then
        local bufname = vim.api.nvim_buf_get_name(buf)
        return string.match(bufname, "%[Command Line%]")
      else
        return false
      end
    end,
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
        -- ["as"] = "@statement.outer",  -- TODO: that's a sentence text object use something else
        -- ["a/"] = "@comment.outer",  -- TODO: mapping for deleting comment EOL (#128)
      },
      include_surrounding_whitespace = true,
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

    swap = {
      enable = true,
      swap_next = {
        ["],"] = "@parameter.inner",
      },
      swap_previous = {
        ["[,"] = "@parameter.inner",
      },
    }
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
local o = vim.o
o.foldexpr = "nvim_treesitter#foldexpr()"
o.foldmethod = "expr"
o.foldlevel = 999

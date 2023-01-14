return {
  -- treesitter integration and related tools
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = "BufReadPre",
    dependencies = {
      -- TS based auto indenting
      "yioneko/nvim-yati",

      -- semantic motions & text objects
      "nvim-treesitter/nvim-treesitter-textobjects",

      -- smart text objects
      "RRethy/nvim-treesitter-textsubjects",

      -- autopairs for text delimiters (e.g. function/end in Lua)
      { "RRethy/nvim-treesitter-endwise", ft = { "ruby", "lua", "vim", "sh" } },

      -- view & interact with treesitter syntax tree
      { "nvim-treesitter/playground", cmd = "TSPlaygroundToggle" },
    },
    config = function()
      require("nvim-treesitter.configs").setup({
        -- these are installed on startup
        ensure_installed = {
          "bash",
          "comment",
          "git_rebase",
          "gitcommit",
        },
        -- install missing parsers on the go
        auto_install = true,

        highlight = {
          enable = true,
          disable = function(lang, buf)
            -- fixes broken highlights inside command line window (#3961)
            if lang == "vim" then
              local bufname = vim.api.nvim_buf_get_name(buf)
              return string.match(bufname, "%[Command Line%]")
            end
          end,
          additional_vim_regex_highlighting = false,
        },

        -- builtin indent module have some flaws
        indent = { enable = false },
        -- using yati instead while it gets fixed
        yati = { enable = true },

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
              ["a."] = "@block.outer",
              ["i."] = "@block.inner",
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
          },
        },

        -- TODO: make PR with queries for Python & Lua
        -- auto expand statement, inner block, outer block
        textsubjects = {
          enable = true,
          prev_selection = "<BS>",
          keymaps = {
            ["<CR>"] = "textsubjects-smart",
            ["a<CR>"] = "textsubjects-container-outer",
            ["i<CR>"] = "textsubjects-container-inner",
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
      local o = vim.o
      o.foldexpr = "nvim_treesitter#foldexpr()"
      o.foldmethod = "expr"
      o.foldlevel = 999
    end
  },
}

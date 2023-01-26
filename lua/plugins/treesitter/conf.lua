local config = {
  -- install these on startup
  ensure_installed = {
    "bash",
    "comment",
    "git_rebase",
    "gitcommit",
  },
  -- install missing parsers on demand
  auto_install = true,

  -- TS based code highlighting
  highlight = {
    enable = true,
    disable = function(lang, buf)
      -- fixes broken highlights inside cmdline window (#3961)
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
  playground = { enable = true },

  matchup = {
    enable = true,
    disable_virtual_text = true,
    include_match_words = true,
  },

  context_commentstring = {
    enable = true,
    enable_autocmd = false,
  },
}


return function()
  require("nvim-treesitter.configs").setup(config)

  -- -- use treesitter to get folding range
  -- local o = vim.o
  -- o.foldexpr = "nvim_treesitter#foldexpr()"
  -- o.foldmethod = "expr"
  -- o.foldlevel = 99
  -- o.foldlevelstart = 99
  -- o.foldtext = "v:lua.getfoldtext()"
  -- _G.getfoldtext = function()
  --   local fstart = vim.fn.getline(vim.v.foldstart)
  --   local fend = string.match(vim.fn.getline(vim.v.foldend), "^%s*(.+)%s*$")
  --   local range = tostring(vim.v.foldend - vim.v.foldstart + 1)
  --   return string.format("%s ... %s  [%sL]", fstart, fend, range)
  -- end
end


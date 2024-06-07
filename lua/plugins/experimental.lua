return {
  -- rip & tear my spaghetti code
  {
    "johngrib/vim-game-code-break",
    cmd = "VimGameCodeBreak",
  },

  -- play a typewriter sound everytime I type in insert mode
  {
    "skywind3000/vim-keysound",
    build = "pip install pysdl2", -- requires 'sdl2' & 'sdl2_mixer'
    cmd = "KeysoundEnable",
    init = function()
      vim.g.keysound_volume = 600
    end,
    enabled = false,
  },

  -- online pair programming
  {
    "jbyuki/instant.nvim",
    cmd = "Instant",
    config = function()
      vim.g.instant_username = "WieeRd"
    end,
  },

  -- preview markdown as TUI
  -- TODO: apply to everything; docs, signatures, scrollbind markdown preview
  {
    "ellisonleao/glow.nvim",
    cmd = "Glow",
    config = function()
      require("glow").setup()
    end,
  },

  -- render LSP docs with glow
  -- BUG: breaks with v1.5.0
  {
    "JASONews/glow-hover.nvim",
    config = function()
      require("glow-hover").setup({
        max_width = 50,
        padding = 10,
        border = "shadow",
        glow_path = "glow",
      })
    end,
    enabled = false,
  },

  -- fancy UI overrides; still very unstable
  {
    "folke/noice.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
      -- "rcarriga/nvim-notify",
    },
    config = function()
      require("noice").setup({
        lsp = {
          -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true,
          },
        },
        -- you can enable a preset for easier configuration
        presets = {
          bottom_search = true, -- use a classic bottom cmdline for search
          command_palette = true, -- position the cmdline and popupmenu together
          long_message_to_split = true, -- long messages will be sent to a split
          inc_rename = false, -- enables an input dialog for inc-rename.nvim
          lsp_doc_border = false, -- add a border to hover docs and signature help
        },
      })

      vim.o.cmdheight = 0
    end,
    enabled = false,
  },

  -- draw ascii diagram
  {
    "jbyuki/venn.nvim",
    config = function()
      vim.keymap.set("x", "<Leader>v", ":VBox<CR>")
    end,
  },
}

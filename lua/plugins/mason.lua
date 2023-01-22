return {
  -- portable package manager for neovim
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end
  },

  -- setup language servers
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      -- "hrsh7th/cmp-nvim-lsp",
      "folke/neodev.nvim",
    },
    config = function()
      local mason_lspconfig = require("mason-lspconfig")
      local lspconfig = require("lspconfig")
      local neodev = require("neodev")

      neodev.setup()

      mason_lspconfig.setup()
      mason_lspconfig.setup_handlers({
        function(server)
          lspconfig[server].setup({})
        end
      })

      -- diagnostic appearance
      -- TODO: custom highlight per diagnostic type (replace 'sign' handler)
      -- https://github.com/Kasama/nvim-custom-diagnostic-highlight
      -- `:h diagnostic-handlers-example`
      vim.diagnostic.config({
        signs = false,
        underline = true,

        -- TODO: diagnostic count (e.g. [1/4])
        -- TODO: override with lsp_lines
        float = {
          border = "solid",
          source = false,
        },

        virtual_text = {
          severity = { min = vim.diagnostic.severity.WARN },
          prefix = " ●",  -- ● ■
          format = function(diagnostic)
            local icon = { "E", "W", "I", "H" }
            -- truncate multi-line diagnostics
            local message = string.match(diagnostic.message, "([^\n]*)\n?")
            return string.format("%s: %s ", icon[diagnostic.severity], message)
          end,
        },
      })

    end
  },
}

return function()
  local mason_lspconfig = require("mason-lspconfig")
  local lspconfig = require("lspconfig")
  local neodev = require("neodev")

  neodev.setup({
    library = {
      enabled = true,
      runtime = true,
      types = true,
      plugins = true,
    },
    setup_jsonls = true,
    override = function(root_dir, options) end,
    lspconfig = true,
  })

  -- defaults that are applied to all servers
  local default_config = {
    -- capabilities = require("cmp_nvim_lsp").default_capabilities(),

    on_attach = function(client, bufnr)
      -- buffer local mapping
      local function map(mode, lhs, rhs, opt)
        opt = opt or {}
        opt.buffer = bufnr
        vim.keymap.set(mode, lhs, rhs, opt)
      end

      local function bind(func, opts)
        return function() func(opts) end
      end

      -- diagnostics
      local dg = vim.diagnostic
      map('n', "[d", dg.goto_prev)
      map('n', "]d", dg.goto_next)
      map('n', "[D", bind(dg.goto_prev, { severity = dg.severity.ERROR }))
      map('n', "]D", bind(dg.goto_next, { severity = dg.severity.ERROR }))

      -- will be replaced with trouble.nvim
      map('n', "<Leader>ld", dg.open_float)
      map('n', "<Leader>ll", dg.setloclist)

      -- goto definition
      map('n', "gd", vim.lsp.buf.definition)
      map('n', "gD", vim.lsp.buf.declaration)
      map('n', "g<C-d>", vim.lsp.buf.type_definition)

      -- list all
      map('n', "<Leader>li", vim.lsp.buf.implementation)
      map('n', "<Leader>lu", vim.lsp.buf.references)

      -- actions
      map('n', "<Leader>lr", vim.lsp.buf.rename)
      map('n', "<Leader>la", vim.lsp.buf.code_action)

      -- docs
      map('n', "K", vim.lsp.buf.hover)
      map('n', "gs", vim.lsp.buf.signature_help)
    end,

    handlers = {
      ["textDocument/hover"] = vim.lsp.with(
        vim.lsp.handlers["textDocument/hover"],
        { border = "solid" }
      )
    }
  }

  mason_lspconfig.setup()
  mason_lspconfig.setup_handlers({
    function(server)
      lspconfig[server].setup({})
    end,

    -- Lua: setup for neovim config & plugin development
    ["sumneko_lua"] = function()
      lspconfig["sumneko_lua"].setup({
        settings = {
          Lua = {
            completion = {
              showWord = "Disable",
            },
            diagnostics = {
              disable = { "redefined-local" },
            },
            workspace = {
              checkThirdParty = false,
            },
          }
        }
      })
    end,

    -- LTeX: disable for gitcommit & enable for plaintext
    ["ltex"] = function()
      lspconfig["ltex"].setup({
        filetypes = {
          "bib",
          -- "gitcommit",
          "markdown",
          "org",
          "plaintex",
          "rst",
          "rnoweb",
          "tex",
          "text",
        }
      })
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

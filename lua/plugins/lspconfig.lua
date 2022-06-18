local vim = vim
local installer = require("nvim-lsp-installer")
local lspconfig = require("lspconfig")


installer.setup({
  ensure_installed = { "sumneko_lua" },
  automatic_installation = false,
  ui = {
    check_outdated_servers_on_open = false,
    border = "none",
    icons = {
      server_installed = "✓",
      server_pending = "➜",
      server_uninstalled = "✗"
    },
  },
})


-- defaults that are applied to all servers
local default_config = {
  capabilities = require("cmp_nvim_lsp").update_capabilities(
    vim.lsp.protocol.make_client_capabilities()
  ),

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

    -- highlight references
    local illuminate = require("illuminate")
    illuminate.on_attach(client)
    map('n', "]r", bind(illuminate.next_reference, { wrap = true }))
    map('n', "[r", bind(illuminate.next_reference, { wrap = true, reverse = true }))
  end,
}

-- override global default config
for k,v in pairs(default_config) do
  lspconfig.util.default_config[k] = v
end


-- configs for each server
local custom_config = {
  ["sumneko_lua"] = require("lua-dev").setup({
    library = {
      types = true,  -- API docs
      vimruntime = true,  -- builtin scripts
      plugins = true,  -- start/opt plugins
    },
    lspconfig = {
      settings = {
        Lua = {
          completion = {
            showWord = "Disable",
          }
        }
      }
    }
  }),
}

-- setup each installed server
local servers = installer.get_installed_servers()
for _, lsp in ipairs(servers) do
  local config = custom_config[lsp.name] or {}
  lspconfig[lsp.name].setup(config)
end


-- appearance
vim.diagnostic.config({
  virtual_text = {
    prefix = " ●", -- Could be '●', '▎', 'x', '■'
  }
})

local vim = vim

local installer = require("nvim-lsp-installer")
local lspconfig = require("lspconfig")
local cmp_nvim_lsp = require("cmp_nvim_lsp")
local lua_dev = require("lua-dev")


installer.setup({
  ensure_installed = { "sumneko_lua" },
  automatic_installation = false,
  ui = {
    check_outdated_servers_on_open = true,
    border = "none",
    icons = {
      server_installed = "✓",
      server_pending = "➜",
      server_uninstalled = "✗"
    },
  },
})


-- default config for all servers
local default_config = {
  capabilities = cmp_nvim_lsp.update_capabilities(
    vim.lsp.protocol.make_client_capabilities()
  ),

  on_attach = function(_, bufnr)
    -- illuminate.on_attach(client)

    -- mappings
    local function map(mode, lhs, rhs, opt)
      opt = opt or {}
      opt.buffer = bufnr
      vim.keymap.set(mode, lhs, rhs, opt)
    end

    -- diagnostics
    local dg = vim.diagnostic
    map('n', "[d", dg.goto_prev)
    map('n', "]d", dg.goto_next)
    map('n', "[D", function() dg.goto_prev({ severity = dg.severity.ERROR }) end)
    map('n', "]D", function() dg.goto_next({ severity = dg.severity.ERROR }) end)

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
}

for k,v in pairs(default_config) do
  lspconfig.util.default_config[k] = v
end


local custom_config = {
  sumneko_lua = lua_dev.setup(),
  -- pyright = {},
}

local servers = installer.get_installed_servers()
for _, lsp in ipairs(servers) do
  lspconfig[lsp.name].setup(custom_config[lsp.name] or {})
end

vim.diagnostic.config({
  virtual_text = {
    prefix = " ●", -- Could be '●', '▎', 'x', '■'
  }
})

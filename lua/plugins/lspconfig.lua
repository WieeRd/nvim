local vim = vim
local installer = require("nvim-lsp-installer")
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


installer.setup({
  ensure_installed = {},
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
  capabilities = require("cmp_nvim_lsp").default_capabilities(),

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

-- set global default config
for k,v in pairs(default_config) do
  ---@diagnostic disable-next-line: assign-type-mismatch
  lspconfig.util.default_config[k] = v
end


-- configs for each server
local custom_config = {
  -- Lua: setup for neovim config & plugin development
  ["sumneko_lua"] = {
    settings = {
      Lua = {
        completion = {
          showWord = "Disable",
        },
        diagnostics = {
          disable = { "redefined-local" },
        }
      }
    }
  },

  -- Python: fix weird hover doc issues
  -- TODO: check if this got fixed
  ["pyright"] = {
    handlers = {
      ["textDocument/hover"] = function(_, result, ctx, config)
        -- local original = vim.lsp.handlers["textDocument/hover"]
        local original = default_config.handlers["textDocument/hover"]

        -- remove backslashes before newline (hard linebreaks)
        if result and result.contents and result.contents.value then
          local s = result.contents.value
          result.contents.value = string.gsub(s, "\\\n", "\n")
          return original(_, result, ctx, config)
        end

        return original(_, result, ctx, config)
      end,
    },
  },

  ["ltex"] = {
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
  }
}

-- setup installed servers
local servers = installer.get_installed_servers()
for _, lsp in ipairs(servers) do
  local config = custom_config[lsp.name] or {}
  lspconfig[lsp.name].setup(config)
end


-- diagnostic appearance
-- TODO: custom highlight per diagnostic type (replace 'sign' handler)
-- https://github.com/Kasama/nvim-custom-diagnostic-highlight
-- `:h diagnostic-handlers-example`
vim.diagnostic.config({
  signs = false,
  underline = true,

  -- TODO: diagnostic count (e.g. [1/4])
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

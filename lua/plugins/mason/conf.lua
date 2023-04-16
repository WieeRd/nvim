local config = {}

config["mason.nvim"] = function()
  require("mason").setup({
    install_root_dir = vim.fn.stdpath("data") .. "/mason",
    PATH = "prepend", -- prepend | append | skip
    log_level = vim.log.levels.INFO,
    max_concurrent_installers = 4,
    ui = {
      check_outdated_packages_on_open = true,
      border = "none",
      width = 0.8,
      height = 0.9,
      icons = {
        -- ✓ ➜ ✗ ◍
        package_installed = "◍",
        package_pending = "➜",
        package_uninstalled = "◍",
      },
    },
  })
end

config["nvim-lspconfig"] = function()
  local mason_lspconfig = require("mason-lspconfig")
  local lspconfig = require("lspconfig")

  -- global default
  local global_config = {
    capabilities = {
      textDocument = {
        -- for `cmp-nvim-lsp`
        completion = {
          completionItem = {
            commitCharactersSupport = true,
            deprecatedSupport = true,
            insertReplaceSupport = true,
            insertTextModeSupport = {
              valueSet = { 1, 2 },
            },
            labelDetailsSupport = true,
            preselectSupport = true,
            resolveSupport = {
              properties = {
                "documentation",
                "detail",
                "additionalTextEdits",
              },
            },
            snippetSupport = true,
            tagSupport = {
              valueSet = { 1 },
            },
          },
          completionList = {
            itemDefaults = {
              "commitCharacters",
              "editRange",
              "insertTextFormat",
              "insertTextMode",
              "data",
            },
          },
          contextSupport = true,
          dynamicRegistration = false,
          insertTextMode = 1,
        },
        -- for `nvim-ufo`
        foldingRange = {
          dynamicRegistration = false,
          lineFoldingOnly = true,
        },
      },
    },
    ---@diagnostic disable-next-line: unused-local
    on_attach = function(client, bufnr)
      -- TODO: should move to LspAttach autocmd
      -- buffer local mapping
      local function map(mode, lhs, rhs, opt)
        opt = opt or {}
        opt.buffer = bufnr
        vim.keymap.set(mode, lhs, rhs, opt)
      end

      local function bind(func, opts)
        return function()
          func(opts)
        end
      end

      -- navigate diagnostics
      local dg = vim.diagnostic
      map("n", "[d", dg.goto_prev)
      map("n", "]d", dg.goto_next)
      map("n", "[D", bind(dg.goto_prev, { severity = dg.severity.WARN }))
      map("n", "]D", bind(dg.goto_next, { severity = dg.severity.WARN }))

      -- NOTE: 'list all' stuff keymaps -> trouble.nvim
      -- NOTE: lsp formatting keymaps -> null-ls.nvim

      -- goto definition
      map("n", "gd", vim.lsp.buf.definition)
      map("n", "gD", vim.lsp.buf.type_definition)

      -- call hierarchy
      map("n", "<Leader>li", vim.lsp.buf.incoming_calls)
      map("n", "<Leader>lo", vim.lsp.buf.outgoing_calls)

      -- actions
      map("n", "<Leader>lr", vim.lsp.buf.rename)
      map("n", "<Leader>la", vim.lsp.buf.code_action)

      -- show docs
      map("n", "K", vim.lsp.buf.hover) -- docs
      map("n", "gK", vim.lsp.buf.signature_help) -- signature
    end,
    handlers = {
      ["textDocument/hover"] = vim.lsp.with(
        vim.lsp.handlers["textDocument/hover"],
        { border = "solid" }
      ),
    },
  }

  -- set global config
  for k, v in pairs(global_config) do
    ---@diagnostic disable-next-line: assign-type-mismatch
    lspconfig.util.default_config[k] = v
  end

  -- setup each servers
  mason_lspconfig.setup()
  mason_lspconfig.setup_handlers({
    function(server)
      lspconfig[server].setup({})
    end,
    -- Lua: setup for neovim config & plugin development
    ["lua_ls"] = function()
      require("neodev").setup({
        library = {
          enabled = true,
          runtime = true,
          types = true,
          plugins = true,
        },
        setup_jsonls = true,
        -- override = function(root_dir, options) end,
        lspconfig = true,
      })

      lspconfig["lua_ls"].setup({
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
          },
        },
      })
    end,
    -- LTeX: disable gitcommit & enable plaintext
    -- TODO: move extra setup to LspAttach
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
        },
        on_attach = function(client, bufnr)
          require("ltex_extra").setup({
            load_langs = { "en-US" },
            init_check = true, -- load dictionaries on startup
            path = vim.fn.stdpath("data") .. "/ltex", -- where to save dictionaries
            log_level = "error",
          })
          lspconfig.util.default_config.on_attach(client, bufnr)
        end,
      })
    end,
  })

  -- diagnostic appearance
  -- TODO: custom highlight per diagnostic type `:h diagnostic-handlers-example`
  -- https://github.com/Kasama/nvim-custom-diagnostic-highlight
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
      prefix = " ●",
      format = function(diagnostic)
        local icon = { "E", "W", "I", "H" }
        -- truncate multi-line diagnostics
        local message = string.match(diagnostic.message, "([^\n]*)\n?")
        return string.format("%s: %s ", icon[diagnostic.severity], message)
      end,
    },
    update_in_insert = false,
    severity_sort = true,
  })
end

config["null-ls.nvim"] = function()
  local mason_null_ls = require("mason-null-ls")
  local null_ls = require("null-ls")

  -- setup linters & formatters installed with mason
  mason_null_ls.setup({
    ensure_installed = {},
    automatic_installation = false,
    automatic_setup = true,
    handlers = {},
  })

  -- sources that are not from mason
  null_ls.setup({
    sources = {
      null_ls.builtins.hover.dictionary,
    },
  })

  -- `gq{motion}` to format range
  -- I had to do this manually since `vim.lsp.formatexpr`
  -- does not provide a way to filter clients
  vim.keymap.set("o", "gq", function()
    local start_lnum = vim.v.lnum
    local end_lnum = start_lnum + vim.v.count - 1

    vim.lsp.buf.format({
      async = false,
      name = "null-ls",
      range = {
        ["start"] = { start_lnum, 0 },
        ["end"] = { end_lnum, 0 },
      },
    })
  end, { expr = true })

  -- `gQ` to format entire buffer
  vim.keymap.set("n", "gQ", function()
    vim.lsp.buf.format({
      async = false,
      name = "null-ls",
    })
  end)
end

config["nvim-dap"] = function()
  local mason_nvim_dap = require("mason-nvim-dap")
  local dap = require("dap")
  local dap_ui = require("dapui")
  local dap_vtext = require("nvim-dap-virtual-text")

  -- setup DAP clients installed with mason
  mason_nvim_dap.setup({
    ensure_installed = {},
    automatic_installation = false,
    automatic_setup = true,
    handlers = {},
  })

  dap_ui.setup({
    -- TODO: move controls to statusline (heirline config)
    controls = { enabled = true },
    icons = {
      collapsed = "▶",
      current_frame = "▶",
      expanded = "▼",
    },
    layouts = {
      {
        elements = {
          { id = "stacks", size = 0.25 },
          { id = "breakpoints", size = 0.25 },
          { id = "scopes", size = 0.25 },
          { id = "watches", size = 0.25 },
        },
        position = "left",
        size = 40,
      },
      {
        elements = {
          { id = "repl", size = 0.5 },
          { id = "console", size = 0.5 },
        },
        position = "bottom",
        size = 10,
      },
    },
  })

  dap_vtext.setup({
    display_callback = function(variable, _buf, _stackframe, _node)
      return (" ◍ %s = %s "):format(variable.name, variable.value)
    end,
  })

  -- automatically open/close dapui
  dap.listeners.after["event_initialized"]["dapui"] = dap_ui.open
  dap.listeners.before["event_terminated"]["dapui"] = dap_ui.close
  dap.listeners.before["event_exited"]["dapui"] = dap_ui.close

  local signs = {
    DapBreakpoint = { text = "○", texthl = "DiagnosticSignError" },
    DapBreakpointCondition = { text = "", texthl = "DiagnosticSignWarn" },
    DapLogPoint = { text = "", texthl = "DiagnosticSignOk" },
    DapStopped = { text = "●", texthl = "DiagnosticSignError" },
    DapBreakpointRejected = { text = "", texthl = "DiagnosticError" },
  }

  local sign_define = vim.fn.sign_define
  for name, attr in pairs(signs) do
    sign_define(name, attr)
  end

  -- TODO: mapping for jumping to a certain UI component
  -- iterate through all windows in the tabpage,
  -- identify component with filetype.

  local mappings = {
    -- start/stop debugging
    ["<Leader>d."] = dap.continue,
    ["<Leader>d,"] = dap.reverse_continue,
    ["<Leader>d "] = dap.pause,
    ["<Leader>dr"] = dap.restart,
    ["<Leader>dt"] = dap.terminate,

    -- breakpoints
    ["<Leader>db"] = dap.toggle_breakpoint,
    ["<Leader>dc"] = function()
      vim.ui.input({ prompt = "Breakpoint Condition: " }, function(input)
        return input and dap.set_breakpoint(input, nil, nil)
      end)
    end,
    ["<Leader>dh"] = function()
      vim.ui.input({ prompt = "Breakpoint Hit Condition: " }, function(input)
        return input and dap.set_breakpoint(nil, input, nil)
      end)
    end,
    ["<Leader>dl"] = function()
      vim.ui.input({ prompt = "Log Point Message: " }, function(input)
        return input and dap.set_breakpoint(nil, nil, input)
      end)
    end,
    ["<Leader>dx"] = dap.clear_breakpoints,

    -- step
    ["<Right>"] = dap.step_over,
    ["<Left>"] = dap.step_back,
    ["<Up>"] = dap.step_out,
    ["<Down>"] = dap.step_into,

    -- UI
    ["<Leader>du"] = dap_ui.toggle,
  }

  local map = vim.keymap.set
  for lhs, rhs in pairs(mappings) do
    map("n", lhs, rhs)
  end
end

return config

local M = {}
local vim = vim

-- FIXME: ASAP: add examples of loader usage
-- some of them have f*cked up types and are nearly unreadable
-- maybe we should switch to teal or moonscript

---@alias NvDots.GlobalValue string | number | table
---@alias NvDots.Globals table<string, NvDots.GlobalValue>

---load table of `:let g:` variables
---@param globals NvDots.Globals
M.load_globals = function(globals)
  local g = vim.g

  for name, value in pairs(globals) do
    g[name] = value
  end
end

---@alias NvDots.OptionValue string | number | table
---@alias NvDots.Options table<string, NvDots.OptionValue>

---load table of `:set` values
---@param options NvDots.Options
M.load_options = function(options)
  local opt = vim.opt

  for name, value in pairs(options) do
    opt[name] = value
  end
end

---@alias NvDots.MapModes "n" | "v" | "s" | "x" | "o" | "i" | "l" | "c" | "t"
---@alias NvDots.MapMode NvDots.MapModes | NvDots.MapModes[]

---@alias NvDots.MapLhs string
---@alias NvDots.MapRhs string | function

---@class NvDots.MapOpts pack {rhs} and {opts} in a single table
---@field [1] NvDots.MapRhs rhs
---@field [string] any option dict

---@alias NvDots.MapPairs table<NvDots.MapLhs, NvDots.MapRhs | NvDots.MapOpts>
---@alias NvDots.Keymaps table<NvDots.MapMode, NvDots.MapPairs>

---load table of `:map` definitions
---@param keymaps NvDots.Keymaps
M.load_keymaps = function(keymaps)
  local map = vim.keymap.set

  for mode, mappings in pairs(keymaps) do
    for lhs, rhs_and_opts in pairs(mappings) do
      local rhs, opts

      if type(rhs_and_opts) == "table" then
        rhs = rhs_and_opts[1]
        rhs_and_opts[1] = nil
        opts = rhs_and_opts
      else
        rhs = rhs_and_opts
        opts = {}
      end

      ---@cast rhs NvDots.MapRhs
      map(mode, lhs, rhs, opts)
    end
  end
end

---@class NvDots.AutocmdSpec pack {event} and {opts} in a single table
---@field [1] string event name
---@field [string] any options dict

---@alias NvDots.Autocmds NvDots.AutocmdSpec[]

---load table of `:autocmd` definitions
---@param autocmds NvDots.Autocmds
M.load_autocmds = function(autocmds)
  local autocmd = vim.api.nvim_create_autocmd
  local augroup = vim.api.nvim_create_augroup
  local group = augroup("nvdots", { clear = true })

  for i = 1, #autocmds do
    local opts = autocmds[i]
    local event = opts[1]
    opts[1] = nil
    opts.group = opts.group or group

    autocmd(event, opts)
  end
end

---@alias Nvdots.CommandImpl string | function

---@class NvDots.CommandOpts pack {command} and {opts} in a single table
---@field [1] Nvdots.CommandImpl target command / callback function
---@field [string] any options dict

---@alias NvDots.Commands table<string, Nvdots.CommandImpl | NvDots.CommandOpts>

---load table of `:command` definitions
---@param commands NvDots.Commands
M.load_commands = function(commands)
  local command = vim.api.nvim_create_user_command

  for name, cmd_and_opts in pairs(commands) do
    local cmd, opts

    if type(cmd_and_opts) == "table" then
      cmd = cmd_and_opts[1]
      cmd_and_opts[1] = nil
      opts = cmd_and_opts
    else
      cmd = cmd_and_opts
      opts = {}
    end

    command(name, cmd, opts)
  end
end

-- FEAT: MAYBE: LSP client configuration
-- neovim lsp is a builtin feature
-- and technically does not require plugins to setup
M.load_lsp = function(_)
  -- lsp = {
  --   -- LspAttach + load_keymaps()
  --   keymaps = {},
  --   -- vim.diagnostic.config()
  --   diagnostic = {},
  -- }
end

---@class NvDots.Plugin
---@field enable boolean | function if the plugins should be loaded
---@field bootstrap boolean | function boostrap lazy.nvim if it's missing
---@field spec LazySpec lazy.nvim plugin specs
---@field opts LazyConfig lazy.nvim setup options

---setup lazy.nvim and load plugins
---@param args NvDots.Plugin
---@return boolean loaded if the plugins have been loaded or not
M.load_plugin = function(args)
  if type(args.enable) == "function" then
    args.enable = args.enable()
  end

  if not args.enable then
    return false
  end

  args.opts.root = args.opts.root or vim.fn.stdpath("data") .. "/lazy"
  local lazypath = args.opts.root .. "/lazy.nvim"

  if not vim.loop.fs_stat(lazypath) then
    if type(args.bootstrap) == "function" then
      args.bootstrap = args.bootstrap()
    end

    if args.bootstrap then
      vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim",
        lazypath,
      })
    else
      return false
    end
  end

  vim.opt.runtimepath:prepend(lazypath)
  require("lazy").setup(args.spec, args.opts)
  return true
end

---@class NvDots.Builtin
---@field globals NvDots.Globals
---@field options NvDots.Options
---@field keymaps NvDots.Keymaps
---@field autocmds NvDots.Autocmds
---@field commands NvDots.Commands

---@class NvDots.ColorScheme
---@field plugin string main theme when plugins are available
---@field builtin string fallback theme when plugins aren't available

---@class NvDots.Config
---@field builtin NvDots.Builtin
---@field plugin NvDots.Plugin
---@field colorscheme NvDots.ColorScheme

---configure entirety of neovim using a single table
---@param cfg NvDots.Config
M.setup = function(cfg)
  if cfg.builtin then
    local builtin = cfg.builtin
    M.load_globals(builtin.globals or {})
    M.load_options(builtin.options or {})
    M.load_keymaps(builtin.keymaps or {})
    M.load_autocmds(builtin.autocmds or {})
    M.load_commands(builtin.commands or {})
  end

  if cfg.plugin and M.load_plugin(cfg.plugin) then
    vim.cmd.colorscheme(cfg.colorscheme.plugin)
  else
    vim.cmd.colorscheme(cfg.colorscheme.builtin)
  end
end

-- FEAT: LATER: make the config reloadable
M.deactivate = function()
  -- * avoid modifying the original table
  -- * receive module path rather than calling `require()`
  -- * global variable to check for 2nd setup `g:nvdots_did_setup`
  -- * unloading code should be lazy loaded (separate submodule maybe)
end

return M

local M = {}
local vim = vim

M.load_globals = function(globals)
  local g = vim.g

  for name, value in pairs(globals) do
    g[name] = value
  end
end

M.load_options = function(options)
  local opt = vim.opt

  for name, value in pairs(options) do
    opt[name] = value
  end
end

M.load_keymaps = function(keymaps)
  local map = vim.keymap.set

  for mode, mappings in pairs(keymaps) do
    for lhs, rhs_and_opts in pairs(mappings) do
      local rhs, opts

      if type(rhs_and_opts) == "string" then
        rhs = rhs_and_opts
        opts = {}
      else
        rhs = rhs_and_opts[1]
        rhs_and_opts[1] = nil
        opts = rhs_and_opts
      end

      map(mode, lhs, rhs, opts)
    end
  end
end

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

M.load_plugin = function(args)
  if type(args.enable) == "function" then
    args.enable = args.enable()
  end

  if not args.enable then
    return false
  end

  local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
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

M.deactivate = function()
  -- FEAT: LATER: make the config reloadable
  -- * avoid modifying the original table
  -- * receive module path rather than calling `require()`
  -- * global/static variable to check for 2nd setup
  -- * unloading code should be lazy loaded (separate submodule maybe)
end

return M

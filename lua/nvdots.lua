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

    if type(cmd_and_opts) == "string" then
      cmd = cmd_and_opts
      opts = {}
    else
      cmd = cmd_and_opts[1]
      cmd_and_opts[1] = nil
      opts = cmd_and_opts
    end

    command(name, cmd, opts)
  end
end

M.setup = function(opts)
  -- TODO:
end

return M

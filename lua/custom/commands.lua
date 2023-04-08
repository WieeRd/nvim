local command = vim.api.nvim_create_user_command

command("Dump", function(opts)
  vim.cmd(("put =execute('%s')"):format(opts.args))
end, { nargs = 1 })

-- TODO: reload configs

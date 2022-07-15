local command = vim.api.nvim_create_user_command

-- TODO: a proper session management plugin would be nice
command("Q", "mks! <Bar> xall", {})
command("E", "so Session.vim", {})

-- TODO: `:Clean` delete hidden & unmodified buffers
-- TODO: `:Dump {command}` dump command output into new buffer

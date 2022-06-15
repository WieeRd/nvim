local vim = vim
command = vim.api.nvim_create_user_command

command("Q", "mks! <Bar> wqa", {})
command("E", "so Session.vim", {})

-- TODO: `:Clean` delete hidden & unmodified buffers
-- TODO: `:Dump {command}` dump command output into new buffer

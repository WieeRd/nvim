local vim = vim
command = vim.api.nvim_create_user_command

command("Q", "mks! <Bar> wqa", {})
command("E", "so Session.vim", {})

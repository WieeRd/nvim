local vim = vim
local autocmd = vim.api.nvim_create_autocmd

-- Custom "User InGitRepo" event. Original VimL code from:
-- https://github.com/wbthomason/packer.nvim/discussions/534
local function check_git_repo()
  -- local cmd = "git rev-parse --is-inside-work-tree"
  -- if vim.fn.system(cmd) == "true\n" then
  if vim.fn.glob(".git") == ".git" then  -- works if vim-rooter is installed
    -- firing event somehow removes startup screen, I'm so confused
    -- vim.api.nvim_exec_autocmds("User", { pattern = "InGitRepo" })
    vim.cmd("packadd vim-fugitive")
    return true  -- remove autocmd after lazy loading git plugins
  end
end

autocmd(
  { "VimEnter", "DirChanged" },
  { callback = function() vim.schedule(check_git_repo) end }
)


-- modifications for each colorscheme
local theme_conf = {}

theme_conf["jellybeans"] = [[
highlight WinSeparator guifg=NONE
]]

theme_conf["tokyonight"] = [[
highlight IndentBlanklineContextChar guifg=#7684c2
highlight WinSeparator guifg=#000000
]]

local function colorscheme(info)
  local config = theme_conf[info.match]
  if config then
    vim.cmd(config)
  end
end

autocmd("ColorScheme", { callback = colorscheme })

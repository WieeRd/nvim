local vim = vim
local fn, api = vim.fn, vim.api
local autocmd = vim.api.nvim_create_autocmd

-- [[ Event: "User InGitRepo" ]]
-- dispatch custom event when cwd is inside git repo

-- Original VimL code from:
-- https://github.com/wbthomason/packer.nvim/discussions/534
local function check_git_repo()
  local cmd = "git rev-parse --is-inside-work-tree"
  if fn.system(cmd) == "true\n" then
    -- XXX: dispatching event somehow clears startup screen
    api.nvim_exec_autocmds("User", { pattern = "InGitRepo" })
    return true  -- removes autocmd after lazy loading git plugins
  end
end

autocmd(
  { "VimEnter", "DirChanged" },
  { callback = function() vim.schedule(check_git_repo) end }
)


-- [[ Event: TabClosed ]]
-- When current tab is closed, go to last accessed tab
-- rather than the tab in the right (default behavior)

local last_left_tab = nil
local last_accessed_tab = nil

local function tableave()
  last_left_tab = api.nvim_get_current_tabpage()
end

local function tabenter()
  last_accessed_tab = last_left_tab
end

local function tabclosed()
  if api.nvim_tabpage_is_valid(last_accessed_tab) then
    api.nvim_set_current_tabpage(last_accessed_tab)
  end
end

autocmd("TabLeave", { callback = tableave })
autocmd("TabEnter", { callback = tabenter })
autocmd("TabClosed", { callback = tabclosed })


-- [[ Event: ColorScheme ]]
-- custom highlight modifications for each theme

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

-- NOTE:

-- sonoakai diff highlights
-- highlight DiffAdd    ctermbg=22 guibg=#394634
-- highlight DiffChange ctermbg=17 guibg=#354157
-- highlight DiffDelete ctermbg=52 guibg=#55393d

-- tokyonight diff highlights
-- highlight DiffAdd    ctermbg=4 guibg=#20303B
-- highlight DiffChange ctermbg=5 guibg=#1F2231
-- highlight DiffDelete ctermfg=12 ctermbg=6 guibg=#37222C

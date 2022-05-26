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
    -- turns out it's not the autocmd itself, it's Fugitive causing this bug
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

local last_left = nil
local last_accessed = nil
local last_entered = nil

local function tab_leave()
  -- since TabLeave is invoked before TabClosed,
  -- `last_left` actually contains the closed tab
  -- by the time `tab_closed()` is called.
  last_left = api.nvim_get_current_tabpage()
end

local function tab_enter()
  -- that is why the real last accessed tab
  -- has to be recorded on TabEnter
  last_accessed = last_left
  last_entered = api.nvim_get_current_tabpage()
end

local function tab_closed()
  if (
    -- only if current tabpage is being closed
    last_left == last_entered
    -- only if last accessed page is still available
    and api.nvim_tabpage_is_valid(last_accessed)
  ) then
    api.nvim_set_current_tabpage(last_accessed)
  end
end

autocmd("TabLeave", { callback = tab_leave })
autocmd("TabEnter", { callback = tab_enter })
autocmd("TabClosed", { callback = tab_closed })


-- [[ Event: ColorScheme ]]
-- override colorscheme's highlight groups in 'after/colors/*.vim'

local function colorscheme(info)
  vim.cmd("runtime! after/colors/" .. info.match .. ".vim")
end

autocmd("ColorScheme", { callback = colorscheme })

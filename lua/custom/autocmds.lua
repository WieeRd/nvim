local vim = vim
local autocmd = vim.api.nvim_create_autocmd

-- TODO: add augroup to clear autocmds when reloading config
-- TODO: 'let g:' style options for each colorscheme
-- TODO: cycle style when applying same colorscheme


-- [[ Custom Event: "User InGitRepo" ]]
-- dispatch custom event when cwd is inside git repo

-- Original VimL code from:
-- https://github.com/wbthomason/packer.nvim/discussions/534
local function check_git_repo()
  local cmd = "git rev-parse --is-inside-work-tree"
  if vim.fn.system(cmd) == "true\n" then
    -- BUG: loading fugitive.vim at VimEnter somehow clears startup screen
    vim.api.nvim_exec_autocmds("User", { pattern = "InGitRepo" })
    return true  -- remove autocmd after lazy loading git plugins
  end
end

autocmd(
  { "VimEnter", "DirChanged" },
  { callback = function() vim.schedule(check_git_repo) end }
)


-- [[ Remember last accessed Tab ]]
-- When current tab is closed, go to last accessed tab
-- (default behavior is switching to the next tab)

local last_left = nil
local last_accessed = nil
local last_entered = nil

local function tab_leave()
  -- since TabLeave is invoked before TabClosed,
  -- `last_left` actually contains the closed tab
  -- by the time `tab_closed()` is called.
  last_left = vim.api.nvim_get_current_tabpage()
end

local function tab_enter()
  -- that is why the real last accessed tab
  -- has to be recorded on TabEnter
  last_accessed = last_left
  last_entered = vim.api.nvim_get_current_tabpage()
end

local function tab_closed()
  if (
    -- only if current tabpage is being closed
    last_left == last_entered
    -- only if last accessed page is still available
    and vim.api.nvim_tabpage_is_valid(last_accessed)
  ) then
    vim.api.nvim_set_current_tabpage(last_accessed)
  end
end

autocmd("TabLeave", { callback = tab_leave })
autocmd("TabEnter", { callback = tab_enter })
autocmd("TabClosed", { callback = tab_closed })


-- [[ Enable 'after/colors' directory ]]
-- 'after/colors/*.vim' will be sourced after running `:colorscheme *`
-- can be used to override highlight groups of each colorscheme

local function colorscheme(info)
  vim.cmd("runtime! after/colors/" .. info.match .. ".vim")

  -- used by smart float bg below
  local float = vim.api.nvim_get_hl_by_name("FloatBorder", true)
  local normal = vim.api.nvim_get_hl_by_name("Normal", true)
  vim.api.nvim_set_hl(0, "FloatBorderLine", {
    fg = float.foreground,
    bg = normal.background,
  })
end

autocmd("ColorScheme", { callback = colorscheme })


-- [[ Smart Float Background ]]
-- only borderless floating windows will get darker background
-- (no more ugly highlights sticking out of border line)

local borderless = { none = true, solid = true, shadow = true }
local nvim_open_win = vim.api.nvim_open_win

-- overriding api function instead of autocmd since
-- it is possible to suppress "Win*", "Buf*" events
vim.api.nvim_open_win = function(buf, enter, config)
  local win = nvim_open_win(buf, enter, config)

  -- only floating windows have "relative" option
  if not config.relative then
    return win
  end

  -- sync float background with `hl-Normal`
  if not borderless[config.border] then
    local winhl = vim.api.nvim_win_get_option(win, "winhl")
    winhl = "NormalFloat:Normal,FloatBorder:FloatBorderLine," .. winhl
    vim.api.nvim_win_set_option(win, "winhl", winhl)
  end

  return win
end

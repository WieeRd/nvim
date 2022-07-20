local vim = vim
local augroup = vim.api.nvim_create_augroup("CustomAutocmds", { clear = true })

local function autocmd(event, opts)
  opts.group = opts.group or augroup
  return vim.api.nvim_create_autocmd(event, opts)
end

local doautocmd = vim.api.nvim_exec_autocmds


-- [[ Custom Event: "User InGitRepo" ]]
-- dispatch custom event when cwd is inside git repo
-- original vimscript code from:
-- https://github.com/wbthomason/packer.nvim/discussions/534

local function check_git_repo()
  local cmd = "git rev-parse --is-inside-work-tree"
  if vim.fn.system(cmd) == "true\n" then
    -- BUG: loading fugitive.vim at VimEnter somehow clears startup screen
    doautocmd("User", { pattern = "InGitRepo" })
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
  -- `last_left` contains the closed tab's handle
  -- by the time `tab_closed()` is called.
  last_left = vim.api.nvim_get_current_tabpage()
end

local function tab_enter()
  -- that is why the real last accessed tab
  -- has to be backed up on TabEnter
  last_accessed = last_left
  last_entered = vim.api.nvim_get_current_tabpage()
end

local function tab_closed()
  if (
    -- current tabpage is being closed
    last_left == last_entered
    -- last accessed page is still available
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
  vim.cmd("runtime! after/colors/common.vim")
  vim.cmd("runtime! after/colors/" .. info.match .. ".vim")

  -- custom hl group used by smart float background below
  local float = vim.api.nvim_get_hl_by_name("FloatBorder", true)
  vim.api.nvim_set_hl(0, "FloatBorderLine", { fg = float.foreground })
end

autocmd("ColorScheme", { callback = colorscheme })


-- [[ Smart Float Background ]]
-- only borderless floating windows will get darker background
-- (no more ugly highlights sticking out of border line)

-- back up original api function
if not _G._nvim_open_win then
  _G._nvim_open_win = vim.api.nvim_open_win
end

-- overriding api function instead of using autocmd
-- because 'WinNew' can be suppressed by 'noautocmd'
local function nvim_open_win(buf, enter, config)
  local win = _G._nvim_open_win(buf, enter, config)
  local border = config.border or "none"

  local borderless = {
    none = true,
    solid = true,
    shadow = true,
  }

  if borderless[border] then
    return win
  end

  if type(border) == "table" then
    for i=1,#border do
      if type(border[i]) == "table" then
        return win
      end
    end
  end

  local winhl = vim.api.nvim_win_get_option(win, "winhl")
  if winhl:find("NormalFloat") or winhl:find("FloatBorder") then
    return win
  end

  winhl = "NormalFloat:Normal,FloatBorder:FloatBorderLine," .. winhl
  vim.api.nvim_win_set_option(win, "winhl", winhl)

  return win
end

-- most GUI clients provide nice borders 
if vim.fn.has("gui_running") == 0 then
  vim.api.nvim_open_win = nvim_open_win
end


-- [[ Terminal Buffer Options ]]
-- wish they had 'terminal' filetype
-- so that I can just use ftplugin

local function term_open()
  -- doautocmd("FileType", { pattern = "terminal" })
  local lopt = vim.opt_local
  lopt.winhl = "Normal:NormalFloat"
  lopt.scrolloff = 0
  lopt.number = false
  lopt.relativenumber = false
end

autocmd("TermOpen", { callback = term_open })


-- TODO: 'let g:{name}_style' style options for each colorscheme
-- TODO: cycle style when applying same colorscheme

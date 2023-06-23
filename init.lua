vim.loader.enable()

require("nvdots").setup({
  builtin = {
    globals = { mapleader = " " },
    options = require("builtin.options"),
    keymaps = require("builtin.keymaps"),
    autocmds = require("builtin.autocmds"),
    commands = require("builtin.commands"),
  },

  plugin = {
    enable = vim.env.USER ~= "root",
    bootstrap = function()
      local prompt = "Would you like to setup plugins? [Y/n] "
      if vim.fn.input({ prompt = prompt }) ~= "n" then
        vim.notify(
          "\nWorking on updates 42%\nDo not turn off your Neovim.\nThis will take a while.",
          vim.log.levels.WARN
        )
        return true
      else
        vim.notify("Continuing without plugins.", vim.log.levels.WARN)
        return false
      end
    end,
    spec = "plugins",
    opts = {
      change_detection = {
        enabled = true,
        notify = false,
      },
      performance = {
        rtp = {
          disabled_plugins = {
            "gzip",
            "matchit",
            "matchparen",
            "netrwPlugin",
            "tarPlugin",
            "tohtml",
            "tutor",
            "zipPlugin",
          },
        },
      },
    },
  },

  colorscheme = {
    plugin = "kanagawa",
    builtin = "habamax",
  },
})

-- FIXME: ASAP: this does not fit anywhere in the nvdots config
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
    for i = 1, #border do
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

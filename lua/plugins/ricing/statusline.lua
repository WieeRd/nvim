local heirline = require("heirline")
local conditions = require("heirline.conditions")
local utils = require("heirline.utils")

local SPACE = { provider = " " }
local ALIGN = { provider = "%=" }
local SEP = { provider = "｜" }
local TRUNC = { provider = "%<" }


---generate color palette for the statusline
---@return table<string, number>
local function generate_palette()
  local get_hl = utils.get_highlight

  -- NOTE: using color names from `:h gui-colors`
  -- Red		  LightRed	    DarkRed
  -- Green	  LightGreen	  DarkGreen	  SeaGreen
  -- Blue	    LightBlue	    DarkBlue	  SlateBlue
  -- Cyan	    LightCyan	    DarkCyan
  -- Magenta	LightMagenta	DarkMagenta
  -- Yellow	  LightYellow	  Brown		    DarkYellow
  -- Gray	    LightGray	    DarkGray
  -- Black	  White
  -- Orange	  Purple		    Violet

  return {
    White = get_hl("Normal").fg,
    Black = get_hl("NormalFloat").bg,

    Red = get_hl("DiagnosticError").fg,
    LightRed = get_hl("Macro").fg,
    DarkRed = get_hl("DiffDelete").bg,
    Green = get_hl("String").fg,
    Blue = get_hl("Function").fg,
    Cyan = get_hl("Special").fg,
    Gray = get_hl("NonText").fg,
    LightGray = get_hl("CursorLine").bg,
    Orange = get_hl("Constant").fg,
    Purple = get_hl("Statement").fg,

    Error = get_hl("DiagnosticError").fg,
    Warn = get_hl("DiagnosticWarn").fg,
    Info = get_hl("DiagnosticInfo").fg,
    Hint = get_hl("DiagnosticHint").fg,

    Add = get_hl("diffAdded").fg,
    Delete = get_hl("diffDeleted").fg,
    Change = get_hl("diffChanged").fg,
  }
end

-- update color palette on colorscheme change
vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function()
    local colors = generate_palette()
    utils.on_colorscheme(colors)
  end,
  group = vim.api.nvim_create_augroup(
    "Heirline",
    { clear = true }
  )
})

-- since heirline is lazy-loaded on "UIEnter" (after "ColorScheme"),
-- the initial color palette needs to be manually generated
heirline.load_colors(generate_palette())


---| {mode} |
local ModeIndicator = {
  condition = conditions.is_active,

  static = {
    mode_names = {
      n = "N",  -- normal
      i = "I",  -- insert
      R = "R",  -- replace
      c = "C",  -- command
      t = "T",  -- terminal

      -- visual
      v = "v",
      V = "V",
      ["\22"] = "B",  -- ^V

      -- select
      s = "S",
      S = "S",
      ["\19"] = "S",  -- ^S

      r = "?",  -- confirm/more prompt
      ["!"] = "!",   -- executing command
    },
    mode_colors = {
      N = "LightRed",
      I = "Green",
      R = "Green",
      C = "Orange",
      T = "Red",

      v = "Cyan",
      V = "Cyan",
      B = "Cyan",

      S = "Purple",
      ["?"] = "Orange",
      ["!"] = "Orange",
    },
  },

  init = function(self)
    self.mode = vim.fn.mode(0)
    self.name = self.mode_names[self.mode]
    self.color = self.mode_colors[self.name]
  end,

  provider = function(self)
    return " " .. self.name .. " "
  end,

  hl = function(self)
    return {
      -- fg = self.color,
      -- bg = "LightGray",
      fg = "Black",
      bg = self.color,
      bold = true,
    }
  end,

  update = "ModeChanged",
}

---| {icon} path/filename.ext [+]  |
local FileInfo = {
  init = function(self)
    self.filename = vim.api.nvim_buf_get_name(0)
  end,

  -- icon
  {
    init = function(self)
      local devicons = require("nvim-web-devicons")

      self.icon, self.icon_color = devicons.get_icon_color_by_filetype(
        vim.bo.filetype,
        { default = true }
      )
    end,
    provider = function(self)
      return " " .. self.icon .. " "
    end,
    hl = function(self)
      return { fg = self.icon_color }
    end
  },

  -- name
  {
    provider = function(self)
      local filename = vim.fn.fnamemodify(self.filename, ":.")
      if filename == "" then return "[No Name]" end
      -- TODO: flexible component
      if not conditions.width_percent_below(#filename, 0.33) then
        filename = vim.fn.pathshorten(filename)
      end
      return filename
    end,
  },

  -- flags
  {
    {
      condition = function()
        return vim.bo.modified
      end,
      provider = " [+]",
      hl = { fg = "Green" },
    },
    {
      condition = function()
        return (not vim.bo.modifiable) or vim.bo.readonly
      end,
      provider = " ",
      hl = { fg = "Orange" },
    },
  },
}

---| E:1 W:2 |
local Diagnostics = {
  condition = conditions.has_diagnostics,

  -- static = {
  --   error_icon = vim.fn.sign_getdefined("DiagnosticSignError")[1].text,
  --   warn_icon = vim.fn.sign_getdefined("DiagnosticSignWarn")[1].text,
  --   info_icon = vim.fn.sign_getdefined("DiagnosticSignInfo")[1].text,
  --   hint_icon = vim.fn.sign_getdefined("DiagnosticSignHint")[1].text,
  -- },

  init = function(self)
    self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
    self.warns = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
  end,

  {
    provider = function(self)
      return self.errors > 0 and ("E:" .. self.errors .. " ")
    end,
    hl = { fg = "Error" },
  },
  {
    provider = function(self)
      return self.warns > 0 and ("W:" .. self.warns .. " ")
    end,
    hl = { fg = "Warn" },
  },

  update = { "DiagnosticChanged", "BufEnter" },
}

---| 128/256:16 |
local Ruler = {
  -- %l = current line number
  -- %L = number of lines in the buffer
  -- %c = column number
  -- %P = percentage through file of displayed window
  provider = " %l/%L:%2c ",
}

---| ▄ |
---@type StatusLine
local ScrollBar ={
  static = {
    sbar = { "█", "▇", "▆", "▅", "▄", "▃", "▂", "▁" }
  },
  provider = function(self)
    local curr_line = vim.api.nvim_win_get_cursor(0)[1]
    local lines = vim.api.nvim_buf_line_count(0)
    local i = math.floor((curr_line - 1) / lines * #self.sbar) + 1
    return string.rep(self.sbar[i], 2)
  end,
  hl = {
    bg = "LightGray",
    fg = "Blue",
  },
}

-- | {mode} | {icon} filename.ext [+] | c foo > m bar | ... | E:1 W:2 | unix | 4 spc | 12:[72/148] |
local StatusLine = {
  hl = function()
    if conditions.is_active() then
      return "StatusLine"
    else
      return "StatusLineNC"
    end
  end,

  -- components
  ModeIndicator,
  FileInfo,
  -- symbols,
  ALIGN,
  Diagnostics,
  Ruler,
  ScrollBar,
}


-- || {1}: {icon, ...} || ... | {n} {icon} {filename} | E:1 W:3 |
local TabLine = {

}


heirline.setup({
  statusline = StatusLine,
  -- tabline = tabline,
})

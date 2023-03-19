local vim = vim
local heirline = require("heirline")
local conditions = require("heirline.conditions")
local utils = require("heirline.utils")


---generate color palette based on current colorscheme
---@return table<string, number>
local function extract_colors()
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
    Yellow = get_hl("Identifier").fg,
    Gray = get_hl("NonText").fg,
    LightGray = get_hl("Comment").fg,
    DarkGray = get_hl("CursorLine").bg,
    Orange = get_hl("Constant").fg,
    Purple = get_hl("Statement").fg,

    Error = get_hl("DiagnosticError").fg,
    Warn = get_hl("DiagnosticWarn").fg,
    Info = get_hl("DiagnosticInfo").fg,
    Hint = get_hl("DiagnosticHint").fg,

    Added = get_hl("diffAdded").fg,
    Deleted = get_hl("diffDeleted").fg,
    Changed = get_hl("diffChanged").fg,
  }
end

-- update color palette on colorscheme change
vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function()
    local colors = extract_colors()
    utils.on_colorscheme(colors)
  end,
  group = vim.api.nvim_create_augroup("Heirline", {
    clear = true,
  })
})


---| {mode} |
local ModeIndicator = {
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
      T = "Purple",

      v = "Cyan",
      V = "Cyan",
      B = "Cyan",

      S = "Purple",
      ["?"] = "Orange",
      ["!"] = "Orange",
    },
  },

  condition = conditions.is_active,

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
      -- fg = "Black",
      -- bg = self.color,
      fg = self.color,
      bg = "DarkGray",
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

  -- FileIcon
  {
    init = function(self)
      local devicons = require("nvim-web-devicons")
      self.icon, self.highlight = devicons.get_icon_by_filetype(
        vim.bo.filetype,
        { default = true }
      )
    end,
    provider = function(self)
      return (" %s "):format(self.icon)
    end,
    hl = function(self)
      return self.highlight
    end
  },

  -- FileName
  {
    provider = function(self)
      local filename = vim.fn.fnamemodify(self.filename, ":.")
      if filename == "" then return "[No Name]" end
      -- TODO: adjust using flexible component
      if not conditions.width_percent_below(#filename, 0.25) then
        filename = vim.fn.pathshorten(filename)
      end
      return filename
    end,
    hl = function()
      return {
        fg = vim.bo.modified and "Green" or nil,
        bold = conditions.is_active(),
      }
    end,
  },

  -- FileFlags
  {
    {
      condition = function()
        return vim.bo.modified
      end,
      provider = " [+]",
      hl = { fg = "Green", bold = true },
    },
    {
      condition = function()
        return (not vim.bo.modifiable) or vim.bo.readonly
      end,
      provider = " ",
      hl = { fg = "Orange" },
    },
  },

  -- space padding
  { provider = " " },
}

---| > ﴯ foo >  bar |
local AerialLocation = {
  static = {
    loose_hierarchy = {
      help = true,
      markdown = true,
    }
  },

  condition = function(self)
    local aerial = require("aerial")
    local exact = not self.loose_hierarchy[vim.bo.filetype]
    self.symbols = aerial.get_location(exact)
    return #self.symbols > 0
  end,

  provider = function(self)
    local children = {}

    for i, symbol in ipairs(self.symbols) do
      local child = {
        -- separator
        {
          -- provider = "> ",
          provider = " ",
          hl = { fg = "Purple" }
        },
        -- symbol kind icon
        {
          provider = symbol.icon,
          hl = function()
            return "CmpItemKind" .. symbol.kind
          end
        },
        -- symbol name
        { provider = (" %s "):format(symbol.name) }
      }
      children[i] = child
    end

    return self:new(children):eval()
  end,

  update = "CursorMoved",
}

---| E:1 W:2 I:3 H:4 |  1  2  3  4 |
local Diagnostics = {
  condition = conditions.has_diagnostics,

  static = {
    -- icons = { "E:", "W:", "I:", "H:" },
    icons = {  " ", " ", " ", " ", },
  },

  init = function(self)
    for i=1,4 do
      local count = #vim.diagnostic.get(0, { severity = i })
      if count > 0 then
        self[i].provider = ("%s%d "):format(self.icons[i], count)
      else
        self[i].provider = ""
      end
    end
  end,

  { hl = "DiagnosticSignError" },
  { hl = "DiagnosticSignWarn" },
  { hl = "DiagnosticSignInfo" },
  { hl = "DiagnosticSignHint" },

  update = { "DiagnosticChanged", "BufEnter" },
}

local Git = {
  condition = conditions.is_git_repo,

  init = function(self)
    self.status_dict = vim.b["gitsigns_status_dict"]
    self.has_changes = self.status_dict.added + self.status_dict.removed + self.status_dict.changed
  end,

  hl = { fg = "Yellow" },

  {
    provider = function(self)
      return " " .. self.status_dict.head
    end,
    hl = { bold = true }
  },
  {
    condition = function(self)
      return self.has_changes
    end,
    provider = "("
  },
  {
    provider = function(self)
      local count = self.status_dict.added or 0
      return count > 0 and ("+" .. count)
    end,
    hl = { fg = "Added" },
  },
  {
    provider = function(self)
      local count = self.status_dict.removed or 0
      return count > 0 and ("-" .. count)
    end,
    hl = { fg = "Deleted" },
  },
  {
    provider = function(self)
      local count = self.status_dict.changed or 0
      return count > 0 and ("~" .. count)
    end,
    hl = { fg = "Changed" },
  },
  {
    condition = function(self)
      return self.has_changes
    end,
    provider = ")"
  },
}

local FileFormat = {
  provider = function()
    return (" %s "):format(vim.bo.fileformat)
  end
}

---| 64:128 |
local Ruler = { provider = " %2l:%2c " }

---| tab:4 | space:2 |
local IndentStyle = {
  provider = function()
    return (" %s:%d "):format(
      vim.bo.expandtab and "space" or "tab",
      vim.bo.tabstop
    )
  end,
}

---| █ | ▇ | ▆ | ▅ | ▄ | ▃ | ▂ | ▁ |
local ScrollBar ={
  static = {
    sbar = { "█", "▇", "▆", "▅", "▄", "▃", "▂", "▁" }
    -- sbar = { '🭶', '🭷', '🭸', '🭹', '🭺', '🭻' }
  },

  provider = function(self)
    local curr_line = vim.api.nvim_win_get_cursor(0)[1]
    local lines = vim.api.nvim_buf_line_count(0)
    local i = math.floor((curr_line - 1) / lines * #self.sbar) + 1
    return string.rep(self.sbar[i], 2)
  end,

  hl = {
    bg = "DarkGray",
    fg = "Blue",
  },
}


local ALIGN = { provider = "%=" }
local TRUNC = { provider = "%<" }
-- local SEP = { provider = "│", hl = { fg = "Gray" } }


---| {mode} | {icon} filename.ext [+] | {c} foo > {f} bar | ... | E:1 W:2 | unix | 4 tab | 128:64 |
local StatusLine = {
  hl = function()
    if conditions.is_active() then
      return "StatusLine"
    else
      return "StatusLineNC"
    end
  end,

  -- components
  -- ModeIndicator,
  FileInfo,
  TRUNC,
  AerialLocation,
  ALIGN,
  Diagnostics,
  -- Git,
  FileFormat,
  IndentStyle,
  Ruler,
  ScrollBar,
}


-- || {1}: {icon, ...} || ... | {n} {icon} {filename} | E:1 W:3 |
-- local TabLine = {}


heirline.setup({
  statusline = StatusLine,
  -- tabline = TabLine,
  -- winbar = WinBar,
  opts = {
    colors = extract_colors(),
  }
})

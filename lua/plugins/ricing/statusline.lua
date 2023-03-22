local vim = vim
local heirline = require("heirline")
local conditions = require("heirline.conditions")
local utils = require("heirline.utils")


---extract color palette from current colorscheme
---@return table<string, number>
local function extract_colors()
  local hl = utils.get_highlight

  return {
    -- FileInfo
    FileModified = hl("String").fg,
    FileReadOnly = hl("Constant").fg,

    -- AerialInfo
    AerialSeparator = hl("Statement").fg,

    -- ScrollBar
    ScrollBarFG = hl("Function").fg,
    ScrollBarBG = hl("CursorLine").bg,
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


---| {icon} path/filename.ext [+]  |
local FileInfo = {
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
    provider = function()
      local filename = vim.api.nvim_buf_get_name(0)
      filename = vim.fn.fnamemodify(filename, ":.")

      if filename == "" then
        return "[No Name]"
      end

      -- TODO: adjust using flexible component
      if not conditions.width_percent_below(#filename, 0.25) then
        filename = vim.fn.pathshorten(filename)
      end

      return filename
    end,
    hl = function()
      return {
        fg = vim.bo.modified and "FileModified" or nil,
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
      hl = { fg = "FileModified", bold = true },
    },
    {
      condition = function()
        return (not vim.bo.modifiable) or vim.bo.readonly
      end,
      provider = " ",
      hl = { fg = "FileReadOnly" },
    },
  },
}

---|  ﴯ foo   bar |
local AerialInfo = {
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
      children[i] = {
        -- separator
        {
          provider = "  ",
          hl = { fg = "AerialSeparator" }
        },
        -- symbol kind icon
        {
          provider = symbol.icon,
          hl = function()
            return "CmpItemKind" .. symbol.kind
          end
        },
        -- symbol name
        { provider = (" %s"):format(symbol.name) }
      }
    end

    return self:new(children):eval()
  end,

  update = { "CursorMoved", "BufEnter" },
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

---| unix | dos | mac |
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
    return self.sbar[i]:rep(2)
  end,

  hl = { fg = "ScrollBarFG", bg = "ScrollBarBG" },
}


---| {icon} filename.ext [+]   ﴯ foo   bar | ... |  1  2  3  4  unix  tab:4  128:64 ▄▄|
local StatusLine = {
  hl = function()
    if conditions.is_active() then
      return "StatusLine"
    else
      return "StatusLineNC"
    end
  end,

  FileInfo,
  { provider = "%<" },  -- truncate here if lacking space
  AerialInfo,
  { provider = "%=" },  -- alignment section separator
  Diagnostics,
  FileFormat,
  IndentStyle,
  Ruler,
  ScrollBar,
}


heirline.setup({
  statusline = StatusLine,
  -- tabline = TabLine,
  -- winbar = WinBar,
  opts = {
    colors = extract_colors(),
  }
})

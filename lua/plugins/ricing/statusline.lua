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

    -- RTFMStatusLine
    DocIcon = hl("Special").fg,

    -- TermStatusLine
    -- TermBG = hl("DiagnosticInfo").fg,
    -- TermFG = hl("NormalFloat").bg,
    TermIcon = hl("Special").fg,
  }
end

---hide the component when lacking space
---lower priority will be hidden first
---@param component StatusLine
---@param priority? integer
---@return StatusLine
local function flexible(component, priority)
  return { flexible = priority or 1, component, {} }
end


---separation point between alignment sections.
---each section will be separated by an equal number of spaces.
local ALIGN = { provider = "%=" }

---truncation starts here when there isn't enough space
local TRUNCATE = { provider = "%<" }


---| {icon} path/filename.ext [+]  |
local FileInfo = {
  -- FileIcon | {icon} |
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
    end,
  },

  -- FileName | path/filename.ext | p/a/t/h/filename.ext |
  {
    provider = function()
      local filename = vim.api.nvim_buf_get_name(0)
      filename = vim.fn.fnamemodify(filename, ":~")  -- relative to $HOME
      filename = vim.fn.fnamemodify(filename, ":.")  -- relative to cwd

      if filename == "" then
        return "[No Name]"
      end

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

  -- FileFlags | [+]  |
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
    -- filetypes where `exact=false` works better
    -- see `:h aerial.get_location`
    loose_hierarchy = {
      help = true,
      man = true,
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
            return "Aerial" .. symbol.kind .. "Icon"
          end
        },
        -- symbol name
        { provider = " " .. symbol.name }
      }
    end

    return self:new(children):eval()
  end,

  update = { "CursorMoved" },
}

---| E:1 W:2 I:3 H:4 |  1  2  3  4 |
local Diagnostics = {
  static = {
    -- icons = { "E:", "W:", "I:", "H:" },
    icons = {  " ", " ", " ", " ", },
  },

  condition = conditions.has_diagnostics,

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
local Ruler = {
  provider = " %2l:%2c ",
}

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


---| {icon} filename.ext [+]   ﴯ foo   bar | ... |  1  2  3  4  unix  tab:4  128:64 ▄▄ |
local FileStatusLine = {
  FileInfo,
  TRUNCATE,
  flexible(AerialInfo, 1),
  ALIGN,
  flexible(Diagnostics, 3),
  flexible(FileFormat, 2),
  flexible(IndentStyle, 2),
  flexible(Ruler, 5),
  flexible(ScrollBar, 4),
}

---| :h options.txt   3. Options summary   'statusline' | ... | 128:64 ▄▄ |
local RTFMStatusLine = {
  static = {
    icons = {
      help = " :h ",
      man = " $ man ",
      markdown = " :h ",
    },
  },

  condition = function(self)
    return self.icons[vim.bo.filetype]
  end,

  -- doc icon
  {
    provider = function(self)
      return self.icons[vim.bo.filetype]
    end,
    hl = function()
      return { fg = "DocIcon", bold = true }
    end
  },

  -- doc name
  {
    provider = function()
      local bufname = vim.api.nvim_buf_get_name(0)
      return vim.fn.fnamemodify(bufname, ":t")
    end,
    hl = function()
      return { bold = conditions.is_active() }
    end,
  },

  TRUNCATE,
  AerialInfo,
  ALIGN,
  Ruler,
  ScrollBar,
}

---|  /bin/bash [+] ... |
local TermStatusLine = {
  condition = function()
    return vim.bo.buftype == "terminal"
  end,

  init = function(self)
    self.insert_mode = vim.fn.mode(0) == "t"
  end,

  -- hl = {
  --   fg = "TermFG",
  --   bg = "TermBG",
  --   bold = true,
  --   force = true,
  -- },

  -- terminal icon
  {
    provider = "  ",
    hl = { fg = "TermIcon" },
  },

  -- terminal name
  {
    provider = function()
      local bufname = vim.api.nvim_buf_get_name(0)
      local termname, _ = bufname:gsub(".*:", "")
      return termname
    end,
    hl = function(self)
      return {
        fg = self.insert_mode and "FileModified" or nil,
        bold = conditions.is_active(),
      }
    end
  },

  -- mode indicator
  {
    condition = function(self)
      return self.insert_mode
    end,
    provider = " [+]",
    hl = {
      fg = "FileModified",
      bold = true,
    }
  },

  TRUNCATE,
  ALIGN,
}

---| the 'root' component that deals with all the conditional statuslines |
local StatusLine = {
  hl = function()
    if conditions.is_active() then
      return "StatusLine"
    else
      return "StatusLineNC"
    end
  end,

  -- stop evaluation at the first component whose `condition` returns true.
  -- this means only one of "~StatusLine" components will be rendered,
  -- depending on the type of the buffer it belongs to.
  fallthrough = false,

  {
    condition = function()
      return vim.bo.buftype ~= ""
    end,
    fallthrough = false,

    RTFMStatusLine,  -- help(:h) & man(:Man) pages
    TermStatusLine,  -- terminal buffers (:term)
    -- plugin special windows (e.g. sidebars)
    -- builtin special windows (e.g. quickfix)
    { provider = "%=[WORKING IN PROCESS]%=", hl = "TODO" }
  },

  -- ordinary file buffers
  FileStatusLine,
}


-- finally, setup heirline and register components
heirline.setup({
  statusline = StatusLine,
  -- tabline = TabLine,
  -- winbar = WinBar,
  opts = {
    colors = extract_colors(),
  }
})

-- update color palette upon colorscheme change
vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function()
    local colors = extract_colors()
    utils.on_colorscheme(colors)
  end,
  group = vim.api.nvim_create_augroup("Heirline", {
    clear = true,
  })
})

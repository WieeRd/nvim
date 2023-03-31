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
    FileProtocol = hl("Special").fg,
    FileModified = hl("String").fg,
    FileReadOnly = hl("Constant").fg,

    -- AerialInfo
    AerialSeparator = hl("Statement").fg,

    -- ScrollBar
    ScrollBarFG = hl("Function").fg,
    ScrollBarBG = hl("CursorLine").bg,

    -- RTFM, Term, Scratch, Quickfix
    SpecialIcon = hl("Special").fg,
    SpecialTitle = hl("Function").fg,

    -- Tabline
    GitBranch = hl("Constant").fg,
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
  init = function(self)
    self.protocol = nil
    self.filename = vim.api.nvim_buf_get_name(0)

    if self.filename == "" then
      self.filename = "[No Name]"
      return
    end

    -- parse URL-like (e.g. protocol://content) buffer names
    local protocol, content = self.filename:match("(%w+)://(.-)/?$")
    if protocol then
      self.protocol = protocol
      self.filename = content
    end

    self.filename = vim.fn.fnamemodify(self.filename, ":~")  -- modify relative to $HOME
    self.filename = vim.fn.fnamemodify(self.filename, ":.")  -- modify relative to cwd
    -- NOTE: relative to local cwd?

    -- if it takes up 25% of the screen, use shortened form
    if not conditions.width_percent_below(#self.filename, 0.25) then
      self.filename = vim.fn.pathshorten(self.filename)  -- foo/bar/baz.lua -> f/b/baz.lua
    end
  end,

  -- FileProtocol | [protocol] |
  {
    condition = function(self)
      return self.protocol
    end,
    provider = function(self)
      return ("[%s]"):format(self.protocol)
    end,
    hl = function()
      return {
        fg = conditions.is_active() and "FileProtocol" or nil,
        bold = true,
      }
    end
  },

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

  -- FileName | p/a/t/h/filename.ext | [protocol] path/filename.ext |
  {
    provider = function(self)
      return self.filename
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
    -- NOTE: parent component must define this method
    get_diagnostic_count = nil,
    -- icons = { "E:", "W:", "I:", "H:" },
    icons = {  " ", " ", " ", " ", },
  },

  init = function(self)
    for severity=1,4 do
      local count = self.get_diagnostic_count(severity)
      if count > 0 then
        self[severity].provider = ("%s%d "):format(self.icons[severity], count)
      else
        self[severity].provider = ""
      end
    end
  end,

  { hl = "DiagnosticSignError" },
  { hl = "DiagnosticSignWarn" },
  { hl = "DiagnosticSignInfo" },
  { hl = "DiagnosticSignHint" },
}

---| Diagnostics: only from current buffer |
local BufferDiagnostics = {
  static = {
    get_diagnostic_count = function(severity)
      return #vim.diagnostic.get(0, { severity = severity })
    end,
  },

  update = {
    "BufEnter",
    "DiagnosticChanged",
  },

  Diagnostics,
}

---| Diagnostics: only from current workspace |
local WorkspaceDiagnostics = {
  static = {
    get_diagnostic_count = function(severity)
      local cwd = vim.loop.cwd()
      local diagnostics = vim.diagnostic.get(nil, { severity = severity })

      local diag_per_buffer = {}  -- number of diagnostics in each buffer
      for _, d in pairs(diagnostics) do
        diag_per_buffer[d.bufnr] = (diag_per_buffer[d.bufnr] or 0) + 1
      end

      local filtered_count = 0  -- only count diagnostics from buffers under cwd
      for bufnr, count in pairs(diag_per_buffer) do
        local bufname = vim.api.nvim_buf_get_name(bufnr)
        if bufname:sub(1, #cwd) == cwd then  -- if path is prefixed with cwd
          filtered_count = filtered_count + count
        end
      end

      return filtered_count
    end,
  },

  update = {
    "DiagnosticChanged",
    callback = function()
      vim.cmd("redrawtabline")
    end,
  },

  Diagnostics,
}

---| unix | dos | mac |
local FileFormat = {
  provider = function()
    return (" %s "):format(vim.bo.fileformat)
  end
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

---| 64:128 |
local Ruler = {
  provider = " %2l:%2c ",
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
  condition = function()
    return vim.bo.buftype == "" or vim.bo.buftype == "nowrite"
  end,

  FileInfo,
  TRUNCATE,
  flexible(AerialInfo, 1),
  ALIGN,
  flexible(BufferDiagnostics, 3),
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

  condition = function()
    return vim.bo.buftype == "help" or vim.bo.filetype == "man"
  end,

  -- doc icon
  {
    provider = function(self)
      return self.icons[vim.bo.filetype]
    end,
    hl = function()
      return { fg = "SpecialIcon", bold = true }
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

  -- terminal icon
  {
    provider = "  ",
    hl = { fg = "SpecialIcon" },
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

---| [ ... Title ... ] | ... [ Title ] ... |
local ScratchStatusLine = {
  condition = function()
    return vim.bo.buftype == "nofile"
  end,

  provider = function()
    local title = nil

    if vim.fn.getcmdwintype() ~= "" then
      -- turns out command line windows are also "nofile" buffers
      title = "Command Line"
    else
      -- filetype but with the first character capitalized
      title, _ = vim.bo.filetype:gsub("^%l", string.upper)
    end

    -- if current window width is same as screen width
    if vim.api.nvim_win_get_width(0) == vim.o.columns then
      -- bottom windows like trouble
      return ("%%=[%s]%%="):format(title)  -- ... [Title] ...
    else
      -- sidebars like aerial
      return ("[%%=%s%%=]"):format(title)  -- [ ... Title ... ]
    end
  end,

  hl = function()
    return {
      fg = conditions.is_active() and "SpecialTitle" or nil,
      bold = true,
    }
  end,
}

---| ... [Quickfix List] :vim/TODO/g **/*.lua ... |
local QuickfixStatusLine = {
  condition = function ()
    return vim.bo.buftype == "quickfix"
  end,

  ALIGN,

  -- [Quickfix List] or [Location List]
  {
    provider = "%q ",
    hl = function()
      local is_active = conditions.is_active()
      return {
        fg = is_active and "SpecialTitle" or nil,
        bold = true,
      }
    end,
  },

  -- the command that produced quickfix list
  {
    provider = function()
      return vim.w["quickfix_title"]
    end,
  },

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

  FileStatusLine,  -- ordinary file buffers
  RTFMStatusLine,  -- help (:h) & man (:Man) pages
  TermStatusLine,  -- terminal buffers (:term)
  ScratchStatusLine,  -- scratch buffers (e.g. sidebars) & cmdline window
  QuickfixStatusLine,  -- quickfix & location list windows

  -- NOTE: haven't dealt with buftype "acwrite" and "prompt".
  -- but I have yet to encounter any buffers with one of those buftypes
  { provider = "%=[WORKING IN PROCESS]%=", hl = "TODO" }
}


--- TODO: |  1:         | ...
local TabList = utils.make_tablist({
  init = function(self)
    local windows = vim.api.nvim_tabpage_list_wins(self.tabpage)
    local buffers = {}
    for i, win in pairs(windows) do
      buffers[i] = vim.api.nvim_win_get_buf(win)
    end
    self.buffers = buffers
  end,

  hl = function(self)
    if self.is_active then
      -- return { bg = "TabLabelSel" }
      return "TablineSel"
    else
      -- return { bg = "TabLabel" }
      return "Tabline"
    end
  end,

  -- "%{N}T" : start of tab page N label
  {
    provider = function(self)
      return "%" .. tostring(self.tabnr) .. "T"
    end,
  },

  -- label header
  {
    provider = function(_)
      -- return "▎"
      return "  "
    end,
    hl = function(self)
      return {
        fg = self.is_active and "SpecialIcon" or nil,
      }
    end
  },

  -- tab number
  {
    provider = function(self)
      return ("%d (%d) "):format(self.tabnr, #self.buffers)
    end,
  },

  -- "%T" : close tab label
  { provider = "%T" },
})

---|  master |
local GitBranch = {
  -- branch icon
  {
    provider = "  ",
    hl = { fg = "GitBranch" },
  },

  -- branch name
  {
    provider = function()
      return vim.b["gitsigns_head"] or vim.g["gitsigns_head"]
    end,
    hl = { bold = true },
  }
}

---|  ~/.config/nvim |
local WorkDir = {
  -- directory icon
  {
    provider = "  ",
    hl = "Directory",
  },

  -- working directory
  {
    provider = function()
      local cwd = vim.loop.cwd()  -- vim.fn.getcwd(0, 0)
      cwd = vim.fn.fnamemodify(cwd, ":~")  -- modify relative to $HOME

      -- if it takes up 50% of the screen, use shortened form
      if not conditions.width_percent_below(#cwd, 0.50) then
        cwd = vim.fn.pathshorten(cwd)  -- ~/foo/bar/ -> ~/f/b/
      end

      return cwd
    end,
    hl = { bold = true },
  },
}

-- TODO: custom tabline
local TabLine = {
  hl = "StatusLine",

  TabList,
  ALIGN,
  GitBranch,
  WorkDir,
  ALIGN,
  WorkspaceDiagnostics,

  -- tab buffers
  -- working directory
  -- git branch
  -- workspace diagnostics
}


-- finally, setup heirline and register components
heirline.setup({
  statusline = StatusLine,
  tabline = TabLine,
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

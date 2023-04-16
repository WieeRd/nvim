local config = {}

config["indent-blankline.nvim"] = function()
  require("indent_blankline").setup({
    char = '┊',
    context_char = '┊',
    show_current_context = true,
    show_current_context_start = false,
  })
end

config["vim-illuminate"] = function()
  local illuminate = require("illuminate")

  illuminate.configure({
    providers = { "lsp", "treesitter" },
    delay = 10,
  })

  local map = vim.keymap.set
  map("n", "]r", illuminate.goto_next_reference)
  map("n", "[r", illuminate.goto_prev_reference)

  -- remove default keymaps
  map("n", "<A-n>", "")
  map("n", "<A-p>", "")
  map("n", "<A-i>", "")
end

config["neoscroll.nvim"] = function()
  require("neoscroll").setup({
    mappings = { "<C-u>", "<C-d>", "<C-b>", "<C-f>", "zt", "zz", "zb" },
    hide_cursor = false,
    easing_function = "quadratic",
  })
end

config["nvim-ufo"] = function()
  local ufo = require("ufo")
  -- TODO: custom virtual text handler
  ufo.setup()

  vim.o.foldlevel = 99
  vim.o.foldlevelstart = 99
  vim.o.foldenable = true

  local map = vim.keymap.set
  map("n", "zR", ufo.openAllFolds)
  map("n", "zM", ufo.closeAllFolds)
  map("n", "z[", ufo.goPreviousClosedFold)
  map("n", "z]", ufo.goNextClosedFold)
end

config["zen-mode.nvim"] = function()
  local zen = require("zen-mode")
  zen.setup()

  local center = {
    window = {
      backdrop = 0.85,
      width = 120,
      height = 1,
      options = {
        cursorline = true,
        relativenumber = false,
      },
    },
    plugins = {
      twilight = { enabled = false }
    },
  }

  local focus = {
    window = {
      backdrop = 1,
      width = 90,
      height = 1,
      options = {
        number = false,
        relativenumber = false,
      }
    },
    on_open = function(win)
      vim.wo[win].scrolloff = vim.fn.float2nr(vim.fn.winheight(win)*0.4)
      vim.cmd("silent! IndentBlanklineDisable")
    end,
    on_close = function(_)
      vim.cmd("silent! IndentBlanklineEnable")
    end
  }

  local map = vim.keymap.set
  map("n", "<Leader>zc", function() zen.toggle(center) end)
  map("n", "<Leader>zf", function() zen.toggle(focus) end)
  map("n", "<Leader>zt", "<Cmd>Twilight<CR>")
end

config["heirline.nvim"] = function()
  local vim = vim
  local heirline = require("heirline")
  local conditions = require("heirline.conditions")
  local utils = require("heirline.utils")


  ---extract color palette from current colorscheme
  ---@return table<string, number>
  local function extract_colors()
    local hl = utils.get_highlight

    return {
      -- Global
      BaseBG = hl("StatusLine").bg,
      ActiveFG = hl("StatusLine").fg,
      InactiveFG = hl("StatusLineNC").fg,
      Modified = hl("String").fg,
      -- FileInfo
      FileProtocol = hl("Special").fg,
      FileReadOnly = hl("Constant").fg,
      -- AerialInfo
      AerialSeparator = hl("Statement").fg,
      -- ScrollBar
      ScrollBarFG = hl("Function").fg,
      ScrollBarBG = hl("CursorLine").bg,
      -- Git
      GitBranch = hl("Constant").fg,
      -- Special StatusLine (RTFM, Term, Scratch, Quickfix)
      SpecialIcon = hl("Special").fg,
      SpecialTitle = hl("Title").fg,
      -- TabLine
      TabLabelSel = hl("Normal").bg,
      TabLabel = hl("StatusLine").bg,
      TabPrefixSel = hl("Special").fg,
      TabPrefix = hl("Comment").fg,
      TabCloseSel = hl("StatusLine").fg,
      TabClose = hl("Comment").fg,
      TabPostfix = hl("NonText").fg,
    }
  end

  ---hide the component when lacking space
  ---lower priority will be hidden first
  ---@param component table
  ---@param priority? integer
  ---@return table
  local function flexible(component, priority)
    return { flexible = priority or 1, component, {} }
  end

  ---set minimal width of a component using item group
  ---@param width integer
  ---@param component table
  ---@return table
  local function min_width(width, component)
    -- %-{width}({component}%)
    return {
      { provider = "%-" .. tostring(width) .. "(" },
      component,
      { provider = "%)" },
    }
  end

  ---alignment section separator
  local ALIGN = { provider = "%=" }
  ---truncation starts here when there isn't enough space
  local TRUNCATE = { provider = "%<" }
  ---literally just a single space what do you expect
  local SPACE = { provider = " " }


  -- | {icon} path/filename.ext [+]  |
  local FileInfo = {
    init = function(self)
      self.protocol = nil
      self.filename = vim.api.nvim_buf_get_name(0)

      if self.filename == "" then
        self.filename = "[No Name]"
        return
      end

      -- parse URL-like (e.g. protocol://content) buffer names
      local protocol, content = self.filename:match("(%w+)://(.-)/*$")
      if protocol then
        self.protocol = protocol
        self.filename = content
      end
    end,
    -- | [protocol] | '{protocol}://' part of URL-like filename
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
    -- | {icon} | filetype icon from nvim-web-devicons
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
    -- | p/a/t/h/filename.ext | filename (shortened if too long)
    {
      provider = function(self)
        local filename = self.filename

        filename = vim.fn.fnamemodify(filename, ":~") -- modify relative to $HOME
        filename = vim.fn.fnamemodify(filename, ":.") -- modify relative to cwd
        -- TODO: relative to local cwd

        -- if it takes up more than 25% of the screen, use shortened form
        if not conditions.width_percent_below(#filename, 0.25) then
          filename = vim.fn.pathshorten(filename) -- foo/bar/baz.lua -> f/b/baz.lua
        end
        return filename
      end,
      hl = function()
        return {
          fg = vim.bo.modified and "Modified" or nil,
          bold = conditions.is_active(),
        }
      end,
    },
    -- | [+]  | modified & readonly indicator
    {
      {
        condition = function()
          return vim.bo.modified
        end,
        provider = " [+]",
        hl = { fg = "Modified", bold = true },
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

  -- |  ﴯ foo   bar |
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

  -- | E:1 W:2 I:3 H:4 |  1  2  3  4 |
  local Diagnostics = {
    static = {
      -- NOTE: parent component must define this method
      get_diagnostic_count = nil,
      -- icons = { "E:", "W:", "I:", "H:" },
      icons = { " ", " ", " ", " ", },
    },
    init = function(self)
      for severity = 1, 4 do
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

  -- | Diagnostics: only from current buffer |
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

  -- | Diagnostics: only from current workspace |
  local WorkspaceDiagnostics = {
    static = {
      get_diagnostic_count = function(severity)
        local cwd = vim.loop.cwd()
        local diagnostics = vim.diagnostic.get(nil, { severity = severity })

        local diag_per_buffer = {} -- number of diagnostics in each buffer
        for _, d in pairs(diagnostics) do
          local bufnr = d["bufnr"]
          diag_per_buffer[bufnr] = (diag_per_buffer[bufnr] or 0) + 1
        end

        local filtered_count = 0 -- only count diagnostics from buffers under cwd
        for bufnr, count in pairs(diag_per_buffer) do
          local bufname = vim.api.nvim_buf_get_name(bufnr)
          if bufname:sub(1, #cwd) == cwd then -- if path is prefixed with cwd
            filtered_count = filtered_count + count
          end
        end

        return filtered_count
      end,
    },
    update = {
      "BufEnter",
      "DiagnosticChanged",
      callback = function()
        vim.cmd("redrawtabline")
      end,
    },
    Diagnostics,
  }

  -- | unix | dos | mac |
  local FileFormat = {
    provider = function()
      return (" %s "):format(vim.bo.fileformat)
    end
  }

  -- | tab:4 | space:2 |
  local IndentStyle = {
    provider = function()
      return (" %s:%d "):format(
        vim.bo.expandtab and "space" or "tab",
        vim.bo.tabstop
      )
    end,
  }

  -- | 64:128 |
  local Ruler = {
    provider = " %2l:%2c ",
  }

  -- | █ | ▇ | ▆ | ▅ | ▄ | ▃ | ▂ | ▁ |
  local ScrollBar = {
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

  -- |  master |
  local GitBranch = {
    condition = function(self)
      self.branch = vim.b["gitsigns_head"] or vim.g["gitsigns_head"]
      return self.branch and self.branch ~= ""
    end,

    -- branch icon
    {
      provider = "  ",
      hl = { fg = "GitBranch" },
    },

    -- branch name
    {
      provider = function(self)
        return self.branch
      end,
      hl = { bold = true },
    }
  }

  -- |  ~/.config/nvim |
  local WorkDir = {
    -- directory icon
    {
      provider = "  ",
      hl = "Directory",
    },

    -- working directory
    {
      provider = function()
        local cwd = vim.loop.cwd()          -- vim.fn.getcwd(0, 0)
        cwd = vim.fn.fnamemodify(cwd, ":~") -- modify relative to $HOME

        -- if it takes up more than 25% of the screen, use shortened form
        if cwd:len() > (0.25 * vim.o.columns) then
          cwd = vim.fn.pathshorten(cwd) -- ~/foo/bar/ -> ~/f/b/
        end

        return cwd
      end,
      hl = { bold = true },
    },
  }


  -- | {icon} filename.ext [+]   ﴯ foo   bar | ... |  1  2  3  4  unix  tab:4  128:64 ▄▄ |
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

  -- | :h options.txt   3. Options summary   'statusline' | ... | 128:64 ▄▄ |
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

  -- |  /bin/bash [+] ... |
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
          fg = self.insert_mode and "Modified" or nil,
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
        fg = "Modified",
        bold = true,
      }
    },
    TRUNCATE,
    ALIGN,
  }

  -- | [ ... Title ... ] | ... [ Title ] ... |
  local SpecialStatusLine = {
    condition = function()
      return vim.bo.buftype == "nofile" or vim.bo.buftype == "prompt"
    end,
    provider = function()
      local title = nil
      local bufname = vim.api.nvim_buf_get_name(0)

      if bufname ~= "" then
        title = vim.fn.expand("%:t")
        title = title:match("%[(.+)%]") or title -- remove surrounding []
      else
        title = vim.bo.filetype
      end

      -- if current window width takes up the whole screen
      if vim.api.nvim_win_get_width(0) == vim.o.columns then
        -- bottom windows like trouble
        return ("%%=[%s]%%="):format(title) -- ... [Title] ...
      else
        -- sidebars like aerial
        return ("[%%=%s%%=]"):format(title) -- [ ... Title ... ]
      end
    end,
    hl = function()
      return {
        fg = conditions.is_active() and "Modified" or "SpecialTitle",
        bold = true,
      }
    end,
  }

  -- | ... [Quickfix List] :vim/TODO/g **/*.lua ... |
  local QuickfixStatusLine = {
    condition = function()
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

  -- | the 'root' component that deals with all the conditional statuslines |
  local StatusLine = {
    hl = function()
      if conditions.is_active() then
        return { fg = "ActiveFG", bg = "BaseBG" }
      else
        return { fg = "InactiveFG", bg = "BaseBG" }
      end
    end,

    -- stop evaluation at the first component whose `condition` returns true.
    -- this means only one of "~StatusLine" components will be rendered,
    -- depending on the type of the buffer it belongs to.
    fallthrough = false,
    FileStatusLine,     -- ordinary file buffers
    RTFMStatusLine,     -- help (:h) & man (:Man) pages
    TermStatusLine,     -- terminal buffers (:term)
    QuickfixStatusLine, -- quickfix & location list windows
    -- DebugStatusLine,  -- TODO: nvim-dap repl statusline with control
    SpecialStatusLine,  -- scratch buffers (e.g. sidebars) & cmdline window

    -- NOTE: haven't dealt with buftype "acwrite"
    -- not sure what to do since I never encountered an acwrite buffer
    { provider = "%=[WORKING IN PROCESS]%=", hl = "TODO" }
  }


  --- TODO: minimized tab label (flexible component)
  -- |  1:     …   | ... |  1  2  3  4   master  ~/.config/nvim |
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
        return { fg = "ActiveFG", bg = "TabLabelSel" }
      else
        return { fg = "InactiveFG", bg = "TabLabel" }
      end
    end,
    -- | %{N}T | start tab label N
    {
      provider = function(self)
        return "%" .. tostring(self.tabnr) .. "T"
      end,
    },
    -- |  | tab label prefix
    {
      provider = function(_)
        -- return "▎"
        return "  "
        -- return "▏ "
      end,
      hl = function(self)
        if self.is_active then
          return { fg = "TabPrefixSel" }
        else
          return { fg = "TabPrefix" }
        end
      end
    },
    -- | {N}: | tab number
    {
      provider = function(self)
        return ("%d: "):format(self.tabnr)
      end,
      hl = { fg = "ActiveFG", bold = true },
    },
    -- |       |     … | tab buffer icons
    min_width(10, {
      provider = function(self)
        local MAX_COUNT = 4    -- max number of icons that can fit in the label
        local ft_count = {}    -- number of buffers with each filetype
        local total_count = 0  -- total number of filtered buffers
        local truncate = false -- total_count > MAX_COUNT

        for _, bufnr in pairs(self.buffers) do
          if total_count == MAX_COUNT then
            truncate = true
            break
          end

          local bo = vim.bo[bufnr]

          -- filter out special buffers
          if not (bo.buftype == "" or bo.buftype == "nowrite") then
            goto continue
          end

          -- nameless buffers are displayed only if modified
          if not (bo.filetype ~= "" or bo.modified) then
            goto continue
          end

          ft_count[bo.filetype] = (ft_count[bo.filetype] or 0) + 1
          total_count = total_count + 1

          ::continue::
        end

        local devicons = require("nvim-web-devicons")
        local children = {}
        for filetype, count in pairs(ft_count) do
          local icon, hl = devicons.get_icon_by_filetype(
            filetype,
            { default = true }
          )

          children[#children + 1] = {
            provider = ("%s "):format(icon):rep(count),
            hl = hl,
          }
        end

        if truncate == true then
          children[#children + 1] = {
            provider = "… ",
            hl = { fg = "InactiveFG" }
          }
        end

        return self:new(children):eval()
      end,
    }),
    -- |  | tab close button
    {
      provider = function(self)
        -- | %{N}X  %X |
        return ("%%%dX  %%X"):format(self.tabnr)
      end,
      hl = function(self)
        return {
          fg = self.is_active and "TabCloseSel" or "TabClose",
        }
      end
    },
    -- | ▕ | tab label postfix
    {
      provider = "▕",
      hl = { fg = "TabPostfix" }
    },
    -- | %T | close tab label
    { provider = "%T" },
  })

  -- |  1:           |  2:     …   | ... |
  local TabLine = {
    hl = {
      fg = "ActiveFG",
      bg = "BaseBG",
    },
    TabList,
    TRUNCATE,
    ALIGN,
    WorkspaceDiagnostics,
    GitBranch,
    WorkDir,
    SPACE,
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
end

config["kanagawa.nvim"] = function()
  require("kanagawa").setup({
    colors = {
      theme = {
        all = {
          ui = {
            bg_gutter = "none",
          },
        },
      },
    },
  })
end

return config

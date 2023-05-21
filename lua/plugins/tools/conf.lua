local config = {}

config["telescope.nvim"] = function()
  local telescope = require("telescope")
  local actions = require("telescope.actions")
  local builtin = require("telescope.builtin")
  local themes = require("telescope.themes")
  local trouble = require("trouble.providers.telescope")

  telescope.setup({
    -- global default
    defaults = {
      prompt_prefix = "  ",
      selection_caret = " ",
      entry_prefix = " ",

      sorting_strategy = "descending",
      layout_strategy = "horizontal",
      layout_config = {
        horizontal = {
          prompt_position = "bottom",
          preview_width = 0.6,
          results_width = 0.8,
        },
        vertical = {
          mirror = false,
        },
        width = 0.7,
        height = 0.8,
        preview_cutoff = 120,
      },

      file_ignore_patterns = { "node_modules" },
      path_display = { "truncate" },

      border = true,

      mappings = {
        i = {
          ["<C-x>"] = trouble.open_with_trouble,
          ["<C-s>"] = actions.select_horizontal,
          ["<C-c>"] = actions.close,
        },
        n = {
          ["<C-x>"] = trouble.open_with_trouble,
          ["<C-s>"] = actions.select_horizontal,
          ["<C-c>"] = actions.close,
        },
      },
    },

    -- configure each builtin pickers
    pickers = {
      ["lsp_document_symbols"] = themes.get_dropdown(),
    },

    -- configure each extension
    extensions = {
      ["ui-select"] = themes.get_dropdown(),
    },
  })

  local map = vim.keymap.set

  telescope.load_extension("fzf")
  telescope.load_extension("ui-select")

  -- I've been using CtrlP for so long
  map("n", "<C-p>", function()
    builtin.find_files(themes.get_dropdown({ previewer = false }))
  end)

  -- meta
  map("n", "<Leader>f ", builtin.builtin)
  map("n", "<Leader>f.", builtin.resume)

  -- find files
  map("n", "<Leader>ff", builtin.find_files) -- NOTE: might use frecency extension
  map("n", "<Leader>fb", builtin.buffers)

  -- searching
  map("n", "<Leader>f/", builtin.current_buffer_fuzzy_find)
  map("n", "<Leader>f?", builtin.live_grep)

  -- others
  map("n", "<Leader>fy", builtin.registers)
  map("n", "<Leader>fc", builtin.quickfix)
  map("n", "<Leader>fl", builtin.loclist)

  -- LSP stuffs
  map("n", "<Leader>fr", builtin.lsp_references)
  map("n", "<Leader>fs", builtin.lsp_document_symbols)
  map("n", "<Leader>fd", function()
    builtin.diagnostics({ bufnr = 0 })
  end)
  map("n", "<Leader>fD", function()
    builtin.diagnostics({ root_dir = true })
  end)
  -- TODO: { severity_limit = vim.diagnostic.severity.WARN }

  -- RTFM, I must
  map("n", "<Leader>fh", builtin.help_tags)
  map("n", "<Leader>fm", builtin.man_pages)

  -- search saved sessions
  local auto_session = require("auto-session")
  auto_session.setup_session_lens()

  -- telescope.load_extension("session-lens")
  local session_lens = require("auto-session.session-lens")
  map("n", "<Leader>fp", session_lens.search_session)
end

config["trouble.nvim"] = function()
  local trouble = require("trouble")

  trouble.setup({
    position = "bottom",
    height = 16,
    width = 50,
    icons = true,
    padding = false,
    auto_preview = false,
  })

  vim.api.nvim_create_autocmd("FileType", {
    pattern = "Trouble",
    group = vim.api.nvim_create_augroup("TroubleConfig", { clear = true }),
    callback = function(_)
      vim.wo.cursorline = true
    end,
  })

  local map = vim.keymap.set
  map("n", "<Leader>xx", "<Cmd>TroubleToggle<CR>")
  map("n", "<Leader>xd", "<Cmd>TroubleToggle document_diagnostics<CR>")
  map("n", "<Leader>xD", "<Cmd>TroubleToggle workspace_diagnostics<CR>")
  map("n", "<Leader>xc", "<Cmd>TroubleToggle quickfix<CR>")
  map("n", "<Leader>xl", "<Cmd>TroubleToggle loclist<CR>")
  map("n", "<Leader>xr", "<Cmd>TroubleToggle lsp_references<CR>")

  map("n", "]x", function()
    trouble.next({ skip_groups = true, jump = true })
  end)
  map("n", "[x", function()
    trouble.previous({ skip_groups = true, jump = true })
  end)
end

config["todo-comments.nvim"] = function()
  local todo = require("todo-comments")

  todo.setup({
    signs = false,
    highlight = {
      multiline = false,
    },
  })

  local map = vim.keymap.set
  map("n", "<Leader>xt", "<Cmd>TodoTrouble<CR>")
  map("n", "<Leader>ft", "<Cmd>TodoTelescope<CR>")

  -- map("n", "]t", todo.jump_next)
  -- map("n", "[t", todo.jump_prev)
end

config["nnn.nvim"] = function()
  local nnn = require("nnn")
  local builtin = require("nnn").builtin

  nnn.setup({
    -- TODO: do I need NnnExplorer?
    -- explorer = {
    --   cmd = "nnn",       -- command overrride (-F1 flag is implied, -a flag is invalid!)
    --   width = 30,        -- width of the vertical split
    --   side = "topleft",  -- or "botright", location of the explorer window
    --   session = "",      -- or "global" / "local" / "shared"
    --   tabs = true,       -- seperate nnn instance per tab
    --   fullscreen = true, -- whether to fullscreen explorer window when current tab is empty
    -- },

    picker = {
      cmd = "nnn",
      style = {
        -- can be absolute(n>1) or ratio(n<1)
        width = 120,
        height = 35,
        border = "solid",
      },
      session = "", -- or "global" / "local" / "shared"
      fullscreen = false, -- whether to fullscreen picker window when current tab is empty
    },

    -- TODO: learn NNN keymaps & come up with mappings without conflict
    mappings = {
      { "<C-t>", builtin.open_in_tab }, -- open file(s) in tab
      { "<C-s>", builtin.open_in_split }, -- open file(s) in split
      { "<C-v>", builtin.open_in_vsplit }, -- open file(s) in vertical split
      -- { "<C-p>", builtin.open_in_preview },   -- open file in preview split keeping nnn focused
      -- { "<C-y>", builtin.copy_to_clipboard }, -- copy file(s) to clipboard
      -- { "<C-w>", builtin.cd_to_path },        -- cd to file directory
      -- { "<C-e>", builtin.populate_cmdline },  -- populate cmdline (:) with file(s)
    },

    windownav = { -- window movement mappings to navigate out of nnn
      -- left = "<C-w>h",
      -- right = "<C-w>l",
      -- next = "<C-w>w",
      -- prev = "<C-w>W",
    },

    buflisted = false, -- whether or not nnn buffers show up in the bufferlist
    quitcd = nil, -- or "cd" / tcd" / "lcd", command to run on quitcd file if found
    offset = false, -- whether or not to write position offset to tmpfile(for use in preview-tui)
    replace_netrw = "picker",
  })

  local map = vim.keymap.set
  map("n", "<C-n>", "<Cmd>NnnPicker %:h<CR>")
  map("n", "g<C-n>", "<Cmd>NnnPicker .<CR>")
end

config["aerial.nvim"] = function()
  local aerial = require("aerial")

  aerial.setup({
    backends = { "treesitter", "lsp", "markdown", "man" },
    layout = {
      width = nil,
      max_width = { 30, 0.2 },
      min_width = 24,

      -- key-value pairs of window-local options for aerial window (e.g. winhl)
      win_opts = { winhl = "Normal:NormalFloat" },

      -- prefer_right, prefer_left, right, left, float
      default_direction = "left",

      -- edge   - open aerial at the far right/left of the editor
      -- window - open aerial to the right/left of the current window
      placement = "window",

      -- Preserve window size equality with (:help CTRL-W_=)
      preserve_equality = false,
    },

    -- Determines how the aerial window decides which buffer to display symbols for
    -- window - aerial window will display symbols for the buffer in the window from which it was opened
    -- global - aerial window will display symbols for the current window
    attach_mode = "window",

    -- List of enum values that configure when to auto-close the aerial window
    -- unfocus, switch_buffer, unsupported
    close_automatic_events = {},

    -- Determines line highlighting mode when multiple splits are visible.
    -- split_width, full_width, last, none
    highlight_mode = "full_width",

    -- Highlight the closest symbol if the cursor is not exactly on one.
    highlight_closest = true,

    -- Highlight the symbol in the source buffer when cursor is in the aerial win
    highlight_on_hover = true,

    -- When jumping to a symbol, highlight the line for this many ms.
    -- Set to false to disable
    highlight_on_jump = false,

    -- Run this command after jumping to a symbol (false will disable)
    post_jump_cmd = "normal! zz",

    -- When true, aerial will automatically close after jumping to a symbol
    close_on_select = true,

    -- Show box drawing characters for the tree hierarchy
    show_guides = true,
    guides = {
      mid_item = "├ ",
      last_item = "└ ",
      nested_top = "│ ",
      whitespace = "  ",
    },
  })

  vim.keymap.set("n", "<Leader>a", aerial.toggle)
end

config["toggleterm.nvim"] = function()
  require("toggleterm").setup({
    size = function(term)
      if term.direction == "horizontal" then
        return math.max(math.min(16, vim.o.lines * 0.25), 5)
      elseif term.direction == "vertical" then
        return math.min(80, math.floor(vim.o.columns * 0.5))
      end
    end,

    open_mapping = "<S-Tab>",
    start_in_insert = true,
    insert_mappings = true,
    terminal_mappings = true,

    persist_size = false,
    persist_mode = false,

    on_open = function(term)
      if term.direction == "float" then
        vim.wo.winhl = ""
      end
    end,

    direction = "float",
    close_on_exit = true,
    auto_scroll = true,

    float_opts = {
      border = "solid",
      width = function(_)
        return math.min(120, vim.o.columns - 6)
      end,
      height = function(_)
        return math.min(35, math.floor(vim.o.lines * 0.7))
      end,
      winblend = nil,
    },
  })
end

return config

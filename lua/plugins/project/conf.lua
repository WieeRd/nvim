local config = {}

config["vim-rooter"] = function()
  vim.g.rooter_cd_cmd = "lcd"
end

config["vim-fugitive"] = function()
  vim.keymap.set("n", "<Leader>gi", "<Cmd>tab G<CR>")
end

config["gitsigns.nvim"] = function()
  local gs = require("gitsigns")

  gs.setup({
    signcolumn = false,  -- :Gitsigns toggle_signs
    numhl      = false,  -- :Gitsigns toggle_numhl
    linehl     = false,  -- :Gitsigns toggle_linehl
    word_diff  = false,  -- :Gitsigns toggle_word_diff
    watch_gitdir = {
      interval = 1000,
      follow_files = true
    },
    attach_to_untracked = true,
    current_line_blame = false,  -- :Gitsigns toggle_current_line_blame
    current_line_blame_opts = {
      virt_text = true,
      virt_text_pos = "eol",  -- "eol" | "overlay" | "right_align"
      delay = 100,
      ignore_whitespace = false,
    },
    current_line_blame_formatter = " <author> (<author_time:%R>) <summary> ",
    sign_priority = 6,
    update_debounce = 100,
    status_formatter = nil,  -- Use default
    max_file_length = 40000,
    preview_config = {
      -- options passed to nvim_open_win
      border = "rounded",
      style = "minimal",
      relative = "cursor",
      row = 1,
      col = 1,
    },
    yadm = { enable = false },
    -- on_attach = on_attach,
  })

  local map = vim.keymap.set

  local function next_hunk()
    if vim.wo.diff then return "]c" end
    vim.schedule(function() gs.next_hunk() end)
    return "<Ignore>"
  end

  local function prev_hunk()
    if vim.wo.diff then return "[c" end
    vim.schedule(function() gs.prev_hunk() end)
    return "<Ignore>"
  end

  local function line_info(blame_opts)
    local acts = gs.get_actions()
    if not acts then
      return false
    end

    local func = acts.preview_hunk or acts.blame_line
    if not func then
      return false
    end

    func(blame_opts)
    return true
  end

  -- hunk motion
  map({ "n", "v" }, "]c", next_hunk, { expr = true })
  map({ "n", "v" }, "[c", prev_hunk, { expr = true })

  -- hunk text object
  map({ "o", "v" }, "ih", gs.select_hunk)
  map({ "o", "v" }, "ah", gs.select_hunk)

  -- hunk actions
  map({ "n", "v" }, "<Leader>gr", ":Gitsigns reset_hunk<CR>")
  map({ "n", "v" }, "<Leader>gs", ":Gitsigns stage_hunk<CR>")
  map({ "n", "v" }, "<Leader>gu", ":Gitsigns undo_stage_hunk<CR>")

  -- buffer actions
  map("n", "<Leader>gR", gs.reset_buffer)  -- :Git restore %
  map("n", "<Leader>gS", gs.stage_buffer)  -- :Git add %
  map("n", "<Leader>gU", gs.reset_buffer_index)  -- :Git reset %

  -- line info: hunk or blame preview
  map("n", "<Leader>gp", function() line_info({ full = true }) end)

  -- toggle diff highlight
  map("n", "<Leader>gh", gs.toggle_linehl)
  map("n", "<Leader>g+", gs.toggle_signs)
  map("n", "<Leader>g0", gs.toggle_numhl)
  map("n", "<Leader>g-", gs.toggle_deleted)

  -- live blame current line
  map("n", "<Leader>gc", gs.toggle_current_line_blame)
end

config["diffview.nvim"] = function()
  local dv = require("diffview")

  dv.setup({
    enhanced_diff_hl = false,  -- See ':h diffview-config-enhanced_diff_hl'
    file_panel = {
      win_config = {  -- See ':h diffview-config-win_config'
        position = "left",
        width = 35,
        win_opts = { winhl = "Normal:NormalFloat" }
      },
    },
    file_history_panel = {
      win_config = {  -- See ':h diffview-config-win_config'
        position = "bottom",
        height = 16,
        win_opts = { winhl = "Normal:NormalFloat" }
      },
    },
    commit_log_panel = {
      win_config = {  -- See ':h diffview-config-win_config'
        win_opts = { winhl = "Normal:NormalFloat" }
      }
    },
    hooks = {  -- See ':h diffview-config-hooks'
      diff_buf_read = function(bufnr)
        vim.wo.relativenumber = false
        vim.wo.cursorline = true
        vim.wo.foldcolumn = "0"
      end
    },
  })

  local map = vim.keymap.set

  -- git diff
  map("n", "<Leader>gd", "<Cmd>DiffviewOpen -uno<CR>")  -- only tracked files
  map("n", "<Leader>gD", "<Cmd>DiffviewOpen<CR>")  -- include untracked files

  -- git log
  map("n", "<Leader>gl", "<Cmd>DiffviewFileHistory %<CR>")  -- current file
  map("x", "<Leader>gl", "<Cmd>'<,'>DiffviewFileHistory<CR>")  -- selected range
  map("n", "<Leader>gL", "<Cmd>DiffviewFileHistory<CR>")  -- project wide

  -- TODO: `:h diffview-merge-tool`
end

return config

local dv = require("diffview")

dv.setup({
  diff_binaries = false,
  enhanced_diff_hl = false,  -- :h diffview-config-enhanced_diff_hl
  git_cmd = { "git" },
  use_icons = true,

  icons = {
    folder_closed = "",
    folder_open = "",
  },

  signs = {
    fold_closed = "",
    fold_open = "",
  },

  file_panel = {
    listing_style = "tree",  -- 'list', 'tree'
    tree_options = {
      flatten_dirs = true,  -- flatten dirs that only contain one single dir
      folder_statuses = "only_folded",  -- 'never', 'only_folded', 'always'
    },
    win_config = {  -- :h diffview-config-win_config
      position = "left",
      width = 35,
    },
  },

  file_history_panel = {
    log_options = {  -- :h diffview-config-log_options
      single_file = {
        diff_merges = "combined",
      },
      multi_file = {
        diff_merges = "first-parent",
      },
    },
    win_config = {  -- :h diffview-config-win_config
      position = "bottom",
      height = 16,
    },
  },

  commit_log_panel = {
    win_config = {},  -- :h diffview-config-win_config
  },

  default_args = {  -- Default args prepended to the arg-list for the listed commands
    DiffviewOpen = {},
    DiffviewFileHistory = {},
  },

  hooks = {  -- :h diffview-config-hooks
    diff_buf_read = function(_)
      vim.wo.foldcolumn = "0"
    end
  },
})


local map = vim.keymap.set

-- git diff
map('n', "<Leader>gd", "<Cmd>DiffviewOpen -uno<CR>")
map('n', "<Leader>gD", "<Cmd>DiffviewOpen<CR>")  -- include untracked

-- git log
map('n', "<Leader>gl", "<Cmd>DiffviewFileHistory %<CR>")  -- current file
map('x', "<Leader>gl", "<Cmd>'<,'>DiffviewFileHistory<CR>")  -- selected range
map('n', "<Leader>gL", "<Cmd>DiffviewFileHistory<CR>")  -- project

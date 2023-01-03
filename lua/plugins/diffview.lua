local dv = require("diffview")

-- TODO: disable relative numbers in diff splits
dv.setup({
  -- https://github.com/sindrets/diffview.nvim#configuration
})


local map = vim.keymap.set

-- git diff
map('n', "<Leader>gd", "<Cmd>DiffviewOpen -uno<CR>")
map('n', "<Leader>gD", "<Cmd>DiffviewOpen<CR>")  -- include untracked

-- git log
map('n', "<Leader>gl", "<Cmd>DiffviewFileHistory %<CR>")  -- current file
map('x', "<Leader>gl", "<Cmd>'<,'>DiffviewFileHistory<CR>")  -- selected range
map('n', "<Leader>gL", "<Cmd>DiffviewFileHistory<CR>")  -- project

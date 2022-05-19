local gs = require("gitsigns")

gs.setup({
  signcolumn = false,  -- Toggle with `:Gitsigns toggle_signs`
  numhl      = false,  -- Toggle with `:Gitsigns toggle_numhl`
  linehl     = false,  -- Toggle with `:Gitsigns toggle_linehl`
  word_diff  = false,  -- Toggle with `:Gitsigns toggle_word_diff`
  watch_gitdir = {
    interval = 1000,
    follow_files = true
  },
  attach_to_untracked = true,
  current_line_blame = false,  -- Toggle with `:Gitsigns toggle_current_line_blame`
  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = "eol",  -- "eol" | "overlay" | "right_align"
    delay = 100,
    ignore_whitespace = false,
  },
  -- current_line_blame_formatter = " <author> (<author_time:%y/%m/%d %H:%M>) <summary> ",
  current_line_blame_formatter = " <author> (<author_time:%R>) <summary> ",
  sign_priority = 6,
  update_debounce = 100,
  status_formatter = nil,  -- Use default
  max_file_length = 40000,
  preview_config = {
    -- options passed to nvim_open_win
    border = "solid",
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
  local func = acts.preview_hunk or acts.blame_line
  if func then func(blame_opts) end
end

-- hunk motion
map({ 'n', 'x' }, "]c", next_hunk, { expr = true })
map({ 'n', 'x' }, "[c", prev_hunk, { expr = true })

-- hunk text object
map({ 'o', 'x' }, "ih", gs.select_hunk)
map({ 'o', 'x' }, "ah", gs.select_hunk)

-- hunk actions
map({ 'n', 'x' }, "ghr", ":Gitsigns reset_hunk<CR>")
map({ 'n', 'x' }, "ghs", ":Gitsigns stage_hunk<CR>")
map({ 'n', 'x' }, "ghu", ":Gitsigns undo_stage_hunk<CR>")

-- buffer actions
map('n', "<Leader>gr", gs.reset_buffer)  -- :Git restore %
map('n', "<Leader>gs", gs.stage_buffer)  -- :Git add %
map('n', "<Leader>gu", gs.reset_buffer_index)  -- :Git reset %

-- line info: hunk or blame preview
map('n', "<Leader>gp", function() line_info({ full = true }) end)

-- toggle diff highlight
map('n', "<Leader>gl", gs.toggle_linehl)
map('n', "<Leader>g+", gs.toggle_signs)
map('n', "<Leader>g0", gs.toggle_numhl)
map('n', "<leader>gd", gs.toggle_deleted)

-- live blame current line
map('n', "<Leader>gc", gs.toggle_current_line_blame)
vim.cmd("highlight link GitSignsCurrentLineBlame CursorLine")

-- Call the setup function to change the default behavior
require("aerial").setup({
  -- Priority list of preferred backends for aerial.
  -- This can be a filetype map (see :help aerial-filetype-map)
  backends = { "treesitter", "lsp", "markdown" },

  -- Enum: persist, close, auto, global
  --   persist - aerial window will stay open until closed
  --   close   - aerial window will close when original file is no longer visible
  --   auto    - aerial window will stay open as long as there is a visible
  --             buffer to attach to
  --   global  - same as 'persist', and will always show symbols for the current buffer
  -- TODO: migrate :h aerial-close-behavior
  -- close_behavior = "auto",

  -- Enable default keybindings for the aerial buffer
  default_bindings = true,

  -- :help SymbolKind
  -- `false` will show all symbols
  filter_kind = {
    "Class",
    "Constructor",
    "Enum",
    "Function",
    "Interface",
    "Module",
    "Method",
    "Struct",
  },

  -- Highlight the closest symbol if the cursor is not exactly on one.
  highlight_closest = true,

  -- Highlight the symbol in the source buffer when cursor is in the aerial win
  highlight_on_hover = true,

  -- When jumping to a symbol, highlight the line for this many ms.
  -- Set to false to disable
  highlight_on_jump = false,

  -- Define symbol icons. You can also specify "<Symbol>Collapsed" to change the
  -- icon when the tree is collapsed at that symbol, or "Collapsed" to specify a
  -- default collapsed icon. The default icon set is determined by the
  -- "nerd_font" option below.
  -- If you have lspkind-nvim installed, it will be the default icon set.
  -- This can be a filetype map (see :help aerial-filetype-map)
  icons = {},

  -- Use symbol tree for folding. Set to true or false to enable/disable
  -- 'auto' will manage folds if your previous foldmethod was 'manual'
  manage_folds = false,
  link_folds_to_tree = false,
  link_tree_to_folds = false,

  -- These control the width of the aerial window.
  -- They can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
  -- min_width and max_width can be a list of mixed types.
  -- max_width = {40, 0.2} means "the lesser of 40 columns or 20% of total"
  layout = {
    min_width = 25,
    max_width = 30,
    -- Enum: prefer_right, prefer_left, right, left, float
    default_direction = "left",
    -- Set to true to only open aerial at the far right/left of the editor
    -- Default behavior opens aerial relative to current window
    placement_editor_edge = false,
  },

  -- Called when aerial attaches to a buffer.
  -- Takes a single `bufnr` argument.
  on_attach = nil,

  -- Called when aerial first sets symbols on a buffer.
  -- Takes a single `bufnr` argument.
  on_first_symbols = nil,

  -- Run this command after jumping to a symbol (false will disable)
  post_jump_cmd = "normal! zz",

  -- When true, aerial will automatically close after jumping to a symbol
  close_on_select = true,

  -- Show box drawing characters for the tree hierarchy
  show_guides = true,

  -- Customize the characters used when show_guides = true
  guides = {
    -- When the child item has a sibling below it
    mid_item = "│ ",
    -- When the child item is the last in the list
    -- last_item = "└─",
    last_item = "│ ",
    -- When there are nested child guides to the right
    nested_top = "│ ",
    -- Raw indentation
    whitespace = "  ",
  },
})

-- https://github.com/stevearc/aerial.nvim/issues/98
-- window proportions are weird after opening aerial window
vim.keymap.set('n', "<Leader>a", "<Cmd>execute 'AerialToggle' <Bar> wincmd =<CR>")

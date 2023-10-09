return {
  langmenu = "en_US",
  termguicolors = true,
  clipboard = "unnamedplus",
  mouse = "nv",

  -- recovery files
  undofile = false,
  swapfile = false,

  updatetime = 150,
  timeoutlen = 300,

  -- what to save in session files
  -- loading folds frequently fail when using semantic folding methods
  -- like treesitter foldexpr or LSP foldingRange with nvim-ufo.
  -- would be great if we can lazy load folds in sessions
  sessionoptions = {
    "blank",
    "curdir",
    -- "folds",
    "help",
    "localoptions",
    "tabpages",
    "terminal",
    "winsize",
  },

  -- split direction
  splitright = true,
  splitbelow = false,

  -- statusline / tabline
  laststatus = 2,
  showtabline = 1,

  -- 'gutter' section
  signcolumn = "auto",
  foldcolumn = "0",
  number = true,
  relativenumber = true,

  -- auto scroll when the cursor is near the edge of the screen
  scrolloff = 7,
  sidescrolloff = 5,
  wrap = false,

  -- informations shown in cmdline
  showcmd = false,
  showmode = false,
  shortmess = "fTOicoltxFn",

  -- special characters
  list = false,
  listchars = { eol = "↲", tab = "» ", trail = "•" },
  fillchars = { diff = " ", eob = " ", fold = " " },

  -- completion menu
  wildmode = "full",
  wildmenu = true,
  pumheight = 10,
  completeopt = { "menu", "menuone", "noselect" },

  -- searching
  hlsearch = true,
  incsearch = true,
  ignorecase = true,
  smartcase = true,
  grepformat = "%f:%l:%c:%m",
  grepprg = "rg --vimgrep",

  -- tabs / indentation
  expandtab = false,
  tabstop = 4,
  shiftwidth = 0,
  autoindent = true,
  cindent = true,

  -- spell
  spelllang = "en",
  spelloptions = "camel",

  -- FEAT: `:h 'diffopt'`
}

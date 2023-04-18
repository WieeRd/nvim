local options = {
  langmenu = "en_US",

  -- recovery files
  undofile = false,
  swapfile = false,
  updatetime = 200,

  -- meta
  termguicolors = true,
  clipboard = "unnamedplus",
  mouse = "nv",

  sessionoptions = table.concat({
    "blank",
    "curdir",
    "folds",
    "help",
    "localoptions",
    "tabpages",
    "terminal",
    "winsize",
  }, ","),

  -- ui
  laststatus = 2,
  showtabline = 1,
  shortmess = "fTOicoltxFn",
  cursorline = false,

  signcolumn = "auto",
  foldcolumn = "0",
  number = true,
  relativenumber = true,

  scrolloff = 7,
  sidescrolloff = 5,
  wrap = false,
  list = false,

  showcmd = false,
  showmode = false,

  listchars = "eol:↲,tab:» ,trail:•",
  fillchars = "diff: ,eob: ,fold: ",

  -- completion menu
  wildmode = "full",
  wildmenu = true,
  pumheight = 10,
  completeopt = "menu,menuone,noselect",

  -- searching
  hlsearch = true,
  incsearch = true,
  ignorecase = true,
  smartcase = true,

  -- tabs / indenting
  expandtab = false,
  tabstop = 4,
  shiftwidth = 0,
  autoindent = true,
  cindent = true,

  -- spell
  spelllang = "en",
  spelloptions = "camel",
}

local o = vim.o
for opt, value in pairs(options) do
  o[opt] = value
end

-- [[ options: ':set' stuff ]] --
local o = vim.o
local opt = vim.opt

o.langmenu = "en_US"
o.encoding = "utf-8"

o.undofile = false
o.swapfile = false
o.updatetime = 200

o.termguicolors = true
o.clipboard = "unnamedplus"
o.mouse = "nv"

opt.sessionoptions = {
  "blank",
  "curdir",
  "folds",
  "help",
  "tabpages",
  "winsize",
  "terminal",
}

-- ui
o.laststatus = 2
o.shortmess = "fTOicoltxFn"
o.cursorline = false

o.signcolumn = "auto"
o.foldcolumn = "0"

o.number = true
o.relativenumber = true

o.scrolloff = 7
o.sidescrolloff = 5

o.wrap = false
o.list = false

o.showcmd = false
o.showmode = false

opt.listchars = { eol = "↲", tab = "» ", trail = "•" }
opt.fillchars = { diff = " ", eob = " ", fold = " " }

-- completion menu
o.wildmode = "full"
o.wildmenu = true
o.pumheight = 10
opt.completeopt = { "menu", "menuone", "noselect" }

-- searching
o.hlsearch = true
o.incsearch = true
o.ignorecase = true
o.smartcase = true

-- tabs / indenting
o.expandtab = false
o.tabstop = 4
o.shiftwidth = 0
o.autoindent = true
o.cindent = true

-- spell
o.spelllang = "en"
o.spelloptions = "camel"

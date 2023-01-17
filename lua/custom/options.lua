-- [[ options: ':set opt' stuff ]] --
local o = vim.o
local opt = vim.opt

o.langmenu = "en_US"
o.encoding = "UTF-8"

o.undofile = false
o.swapfile = false

o.termguicolors = true
o.clipboard = "unnamedplus"
o.mouse = "a"

o.hidden = true
o.updatetime = 200

opt.shortmess:append("c")
opt.sessionoptions:remove("buffers")

-- UI
o.laststatus = 2
o.cursorline = false

o.signcolumn = "auto"
o.foldcolumn = "0"

o.number = true
o.relativenumber = true

o.scrolloff = 7
o.sidescrolloff = 5

o.wrap = false
o.list = false

opt.listchars = { eol = "↲", tab = "» ", trail = "•" }
opt.fillchars = { diff = " ", eob = " ", fold = " " }

-- completion menu
opt.completeopt = { "menu", "menuone", "noselect" }
o.wildmode = "full"
o.wildmenu = true
o.pumheight = 10

-- searching
o.hlsearch = true
o.incsearch = true
o.ignorecase = true
o.smartcase = true

-- tabs / indentation
o.expandtab = false
o.tabstop = 4
o.shiftwidth = 0
o.autoindent = true
o.cindent = true

-- spell
o.spelllang = "en"
o.spelloptions = "camel"

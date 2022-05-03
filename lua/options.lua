local opt = vim.opt

opt.langmenu = "en_US"
opt.encoding = "UTF-8"

-- TODO: 'undodir'
opt.undofile = false
opt.swapfile = false

opt.termguicolors = true
opt.clipboard = "unnamedplus"
opt.mouse = ""

opt.hidden = true
opt.updatetime = 200
opt.shortmess:append("c")

-- ui
opt.laststatus = 1
opt.signcolumn = "no"
opt.number = true
opt.wrap = false
opt.cursorline = false
opt.scrolloff = 5
opt.sidescrolloff = 5

-- completion menu
opt.wildmode = "full"
opt.wildmenu = true
opt.pumheight = 10

-- searching
opt.hlsearch = true
opt.incsearch = true
opt.ignorecase = true
opt.smartcase = true

-- tabs / indentation
opt.expandtab = false
opt.tabstop = 4
opt.shiftwidth = 0

-- autoindent
opt.autoindent = true
opt.cindent = true

-- remove '~' in the lines after EOF
-- opt.fillchars="eob: "

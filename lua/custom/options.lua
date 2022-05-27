-- [[ options: ':set opt' stuff ]] --
local opt = vim.opt

opt.langmenu = "en_US"
opt.encoding = "UTF-8"

opt.undofile = false
opt.swapfile = false

opt.termguicolors = true
opt.clipboard = "unnamedplus"
opt.mouse = ""

opt.hidden = true
opt.updatetime = 200
opt.shortmess:append("c")

-- UI
opt.laststatus = 2
opt.signcolumn = "auto"
opt.foldcolumn = "0"  -- "auto:9"
opt.number = true
opt.relativenumber = true
opt.wrap = false
opt.cursorline = false
opt.scrolloff = 7
opt.sidescrolloff = 5

-- completion menu
opt.completeopt = { "menu", "menuone", "noselect" }
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

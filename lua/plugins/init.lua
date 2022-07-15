vim.cmd("packadd packer.nvim")

local packer = require("packer")
local util = require("packer.util")
local use = packer.use

local config = {
  package_root = util.join_paths(
    vim.fn.stdpath("data"), "site", "pack"
  ),
  compile_path = util.join_paths(
    vim.fn.stdpath("config"), "plugin", "packer_compiled.lua"
  ),
  display = {
    open_fn = function()
      return util.float({ border = "solid" })
    end,
    prompt_border = "rounded"
  },
  profile = { enable = true, threshold = 0 },
  autoremove = false,
}

packer.init(config)
packer.reset()

local function sync()
  package.loaded["plugins"] = nil
  require("plugins")
  packer.sync()
end

local function compile()
  package.loaded["plugins"] = nil
  require("plugins")
  packer.compile()
  packer.clean()
end

local map = vim.keymap.set
map('n', "<Leader>ps", sync)
map('n', "<Leader>pc", compile)
map('n', "<Leader>pt", packer.status)
map('n', "<Leader>pp", packer.profile_output)
map('n', "<Leader>pl", ":PackerLoad ")

------------------------------------------
-- [[ Meta: Manage & Profile plugins ]] --
------------------------------------------

-- optimize loading lua modules by caching
use { "lewis6991/impatient.nvim", disable = false }

-- packer.nvim can manage itself
use {
  "wbthomason/packer.nvim",
  cmd = "Packer*",
  keys = "<Leader>p",
  config = [[require("plugins")]],
}

-- measure & profile startup time
use { "dstein64/vim-startuptime", cmd = "StartupTime" }

-- provide filetype icons
use "kyazdani42/nvim-web-devicons"

-- collection of useful nvim-lua functions
use "nvim-lua/plenary.nvim"


----------------------
-- [[ Treesitter ]] --
----------------------

-- syntax highlight, smarter '=' operator
use {
  "nvim-treesitter/nvim-treesitter",
  run = ":TSUpdate",
  config = [[require("plugins.treesitter")]],
}

-- context based text object
-- TODO: PR for better Python & Lua support
use "RRethy/nvim-treesitter-textsubjects"

-- motions & text objects for class, function, statement.
use { "nvim-treesitter/nvim-treesitter-textobjects" }

-- autopairs for text delimiters (e.g. function-end in lua)
use { "RRethy/nvim-treesitter-endwise", ft = { "ruby", "lua", "vim", "sh" } }

-- view & interact with treesitter syntax tree
use { "nvim-treesitter/playground", cmd = "TSPlaygroundToggle" }

-- treesitter based auto indentation
use "yioneko/nvim-yati"


------------------------------------------
-- [[ Editing: Keybinds for the lazy ]] --
------------------------------------------

-- automatically insert/delete closing pair
use {
  "windwp/nvim-autopairs",
  event = "InsertEnter",
  config = [[vim.schedule(function() require("plugins.autopairs") end)]]
}

-- better % operator, highlight matching pair
use {
  "andymass/vim-matchup",
  config = [[vim.g.matchup_matchparen_offscreen = { method = "" }]],
}

-- more inside/around text objects
use "wellle/targets.vim"

-- manipulate surrounding pair
use { "tpope/vim-surround", requires = "tpope/vim-repeat" }

-- handy bracket[] mappings
-- TODO: translate to lua and put them in "custom.keymaps"
use { "tpope/vim-unimpaired", requires = "tpope/vim-repeat" }

-- operators for commenting (gc, gb)
use {
  "numToStr/Comment.nvim",
  keys = {
    { 'n', "gc" },
    { 'n', "gb" },
    { 'x', "gc" },
    { 'x', "gb" },
  },
  config = [[require("plugins.comment")]],
  -- correctly comment embedded codes in other languages
  requires = "JoosepAlviste/nvim-ts-context-commentstring"
}

-- split/join multi-line statement
use "AndrewRadev/splitjoin.vim"

-- align code to a given character
use {
  "junegunn/vim-easy-align",
  keys = { { 'n', "ga" }, { 'x', "ga" } },
  config = [[vim.keymap.set({'n', 'x'}, "ga", "<Plug>(EasyAlign)")]],
}

-- 'sneak' mode; jump to anywhere on screen
use {
  "phaazon/hop.nvim",
  branch = "v1",
  keys = {
    { 'n', "<Leader>j" },
    { 'n', "g/" },
    { 'x', "<Leader>j" },
    { 'x', "g/" },
  },
  config = function()
    local hop = require("hop")
    hop.setup()
    vim.keymap.set({ 'n', 'x' }, "<Leader>j", hop.hint_words)  -- 'jump'
    vim.keymap.set({ 'n', 'x' }, "g/", hop.hint_patterns)  -- 'goto search'
  end
}


---------------------------
-- [[ Git Integration ]] --
---------------------------

-- automatically cd to project root (detects .git)
use { "airblade/vim-rooter", config = [[vim.g.rooter_cd_cmd = 'lcd']] }

-- wrapped ex command `:Git`, interactable git status
use {
  "tpope/vim-fugitive",
  event = "User InGitRepo",
  config = [[vim.keymap.set('n', "<Leader>gi", "<Cmd>tab G<CR>")]],
}

-- view and manipulate hunks (chunk of git diffs)
use {
  "lewis6991/gitsigns.nvim",
  event = "User InGitRepo",
  config = [[require("plugins.gitsigns")]],
  requires = "tpope/vim-repeat"
}

-- commit log browser (interactable `git log`)
use { "junegunn/gv.vim", event = "User InGitRepo" }

-- view all modified files
use {
  "sindrets/diffview.nvim",
  event = "User InGitRepo",
  config = [[require("plugins.diffview")]],
  requires = "nvim-lua/plenary.nvim",
}


-------------------------
-- [[ UI Components ]] --
-------------------------

-- fancy notification
use {
  "rcarriga/nvim-notify",
  config = [[vim.notify = require("notify")]],
  disable = true,
}

-- fancy statusline
use {
  "nvim-lualine/lualine.nvim",
  config = [[require("lualine").setup()]],
  requires = { "SmiteshP/nvim-gps" },
  disable = true,
}

-- fancy statusline
use {
  "feline-nvim/feline.nvim",
  config = [[require("feline").setup()]],
  disable = true,
}

-- fancy tabline
use {
  "nanozuki/tabby.nvim",
  event = "TabNew",
  config = [[require("plugins.tabby")]],
  disable = true,
}


-----------------------
-- [[ LSP client ]] --
-----------------------

-- configure built-in LSP client
use {
  "neovim/nvim-lspconfig",
  -- event = "BufReadPre",
  config = [[require("plugins.lspconfig")]],
  requires = {
    "williamboman/nvim-lsp-installer",
    "hrsh7th/cmp-nvim-lsp",
    "folke/lua-dev.nvim",
  },
}

-- highlight references of the symbol under the cursor
use {
  "RRethy/vim-illuminate",
  module = "illuminate",
  config = [[vim.cmd("IlluminationDisable")]],
}

-- show function signature while typing
use {
  "ray-x/lsp_signature.nvim",
  config = function()
    require("lsp_signature").setup({
      hint_enable = true,
      hint_prefix = "● ",
      cursorhold_update = false,
    })
  end
}

-- view code outline (tree of symbols)
use {
  -- TODO: better symbol tree folding
  -- "~/Code/aerial.nvim",
  "stevearc/aerial.nvim",
  module = "aerial",
  keys = "<Leader>a",
  config = [[require("plugins.aerial")]],
}


----------------------
-- [[ Completion ]] --
----------------------

-- use { "L3MON4D3/LuaSnip" }
-- use { "danymat/neogen" }

use {
  "hrsh7th/nvim-cmp",
  event = { "InsertEnter", "CmdlineEnter" },
  config = [[require("plugins.cmp")]],
  requires = {
    -- provide icons for completion items
    { "onsails/lspkind.nvim", config = [[require("lspkind").init()]] },
    -- completion sources
    { "hrsh7th/cmp-nvim-lsp", after = "nvim-cmp" },
    { "hrsh7th/cmp-buffer", after = "nvim-cmp" },
    { "hrsh7th/cmp-path", after = "nvim-cmp" },
    { "hrsh7th/cmp-cmdline", after = "nvim-cmp" },
    { "f3fora/cmp-spell", after = "nvim-cmp" },
    { "saadparwaiz1/cmp_luasnip", after = "nvim-cmp" },
  }
}

-- pair programming with AI because I don't have any friends
use { "github/copilot.vim", cmd = "Copilot" }


------------------------------------------
-- [[ Aesthetic: Visual Enhancements ]] --
------------------------------------------

-- indentation level indicator
use {
  "lukas-reineke/indent-blankline.nvim",
  config = function()
    require("indent_blankline").setup({
      char = '┊',
      show_current_context = true,
    })
  end
}

-- default folded line looks like SHIT
-- use "anuvyklack/pretty-fold.nvim"  -- https://github.com/AdamWagner/stackline/issues/42

-- search info at the end of each line with virtual text
-- use "kevinhwang91/nvim-hlslens"

-- preview jump destination when using `:[number]` command
-- use "nacro90/numb.nvim"

-- highlight other uses of the word under the cursor
-- use "RRethy/vim-illuminate"  -- TODO: lsp integration

use { "norcalli/nvim-colorizer.lua", config = [[require("colorizer").setup()]] }

-- smooth physics based scrolling motion
use "psliwka/vim-smoothie"

-- distraction free: centers code and disable UI components
use {
  "folke/zen-mode.nvim",
  cmd = "ZenMode",
  keys = "<Leader>z",
  wants = "twilight.nvim",
  config = [[require("plugins.zen-mode")]],
}

-- distraction free: dim everything except current *context*
use { "folke/twilight.nvim", cmd = "Twilight" }

-- distraction free: dim everything except current *paragraph*
use { "junegunn/limelight.vim", cmd = "Limelight" }


------------------------------------------
-- [[ Colorscheme collection ]] --
------------------------------------------

-- required by themes created with lush
use { "rktjmp/lush.nvim", opt = true }

-- WieeRd's favorite throughout the years
use { "nanotech/jellybeans.vim", opt = true }      -- 2019
use { "dracula/vim", as = "dracula", opt = true }  -- 2020
use { "sainnhe/sonokai", opt = true }              -- 2021
use { "folke/tokyonight.nvim", opt = false }       -- 2022*

-- WieeRd's favorite out the years
use { "rebelot/kanagawa.nvim", opt = true }        -- 1831
use { "vim-scripts/greenvision", opt = true }      -- 2077

-- trying out other themes for fun
use { "marko-cerovac/material.nvim", opt = true }
use { "olimorris/onedarkpro.nvim", opt = true }
use { "metalelf0/jellybeans-nvim", opt = true, wants = "lush.nvim" }


------------------------------
-- [[ Misc: Mostly memes ]] --
------------------------------

-- rip & tear my spaghetti code
use "johngrib/vim-game-code-break"

-- play a typewriter sound everytime I type in insert mode
use {
  "skywind3000/vim-keysound",
  -- installed as a meme, but I ended up loving it
  -- so it's enabled by default now lol
  cmd = "KeysoundEnable",
  -- event = "InsertEnter",
  -- config = [[vim.schedule(function() vim.cmd("KeysoundEnable") end)]],
  run = "pip install pysdl2"  -- requires 'sdl2' & 'sdl2_mixer'
}

-- fixes cursorhold blocking bug
use "antoinemadec/FixCursorHold.nvim"

-- fixes 'gx' keybind (open in external app)
use { "felipec/vim-sanegx", keys = "gx" }

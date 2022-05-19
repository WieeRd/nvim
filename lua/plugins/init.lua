local vim = vim
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
      return util.float({ border = "shadow" })
    end,
    prompt_border = "shadow"
  },
  profile = { enable = true, threshold = 0 },
  autoremove = false,
}

packer.init(config)
packer.reset()

------------------------------------------
-- [[ Meta: Manage & Profile plugins ]] --
------------------------------------------

-- optimize loading lua modules by caching
use { "lewis6991/impatient.nvim", disable = false }

-- packer.nvim can manage itself
-- TODO: create <Leader>p keymaps
use { "wbthomason/packer.nvim", cmd = "Packer*", config = [[require("plugins")]] }

-- measure & profile startup time
use { "dstein64/vim-startuptime", cmd = "StartupTime" }


----------------------
-- [[ Treesitter ]] --
----------------------

-- syntax highlight, smarter '=' operator
use {
  "nvim-treesitter/nvim-treesitter",
  run = ":TSUpdate",
  config = [[require("plugins.treesitter")]],
}

-- motions & text objects for class, function, statement.
use { "nvim-treesitter/nvim-treesitter-textobjects" }

-- autopairs for text delimiters (e.g. function-end in lua)
use { "RRethy/nvim-treesitter-endwise", ft = { "ruby", "lua", "vim", "sh" } }

-- view & interact with treesitter syntax tree
use { "nvim-treesitter/playground", cmd = "TSPlaygroundToggle" }


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
    local vim = _G.vim
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
}

-- git commit browser (interactable `git log`)
use { "junegunn/gv.vim", cmd = "GV" }

-- use "lewis6991/gitsigns.nvim"
-- use "airblade/vim-gitgutter"


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
  wants = "twilight.nvim",  -- wasn't documented in README but somehow works what
  config = [[require("plugins.zen-mode")]],
}

-- distraction free: dim everything except current *context*
use { "folke/twilight.nvim", cmd = "Twilight" }

-- distraction free: dim everything except current *paragraph*
use { "junegunn/limelight.vim", cmd = "Limelight" }


------------------------------------------
-- [[ Colorscheme collection ]] --
------------------------------------------

-- generate missing LSP highlight groups
use "folke/lsp-colors.nvim"

-- required by themes created with lush
use { "rktjmp/lush.nvim", opt = true }

-- WieeRd's favorite throughout the years
use "nanotech/jellybeans.vim"  -- 2019
use { "dracula/vim", as = "dracula" }  -- 2020
use "sainnhe/sonokai"  -- 2021
use "folke/tokyonight.nvim"  -- 2022
use "vim-scripts/greenvision"  -- 2077

-- trying out other themes for fun
use { "marko-cerovac/material.nvim", opt = true }  -- require("material.functions").toggle_style()
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

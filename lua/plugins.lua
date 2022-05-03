local vim = vim
vim.cmd("packadd packer.nvim")

local packer = require("packer")
local util = require("packer.util")

local function spec()
  local use = packer.use
  use {
    "wbthomason/packer.nvim",
    cmd = "Packer*",
    config = "require('plugins')",
  }
  -- use {
  --   "lewis6991/impatient.nvim",
  --   config = "require('impatient').enable_profile()"
  -- }
  use { "dstein64/vim-startuptime", cmd = "StartupTime" }

  -- TODO: Editing
  -- "jiangmiao/auto-pairs"
  -- "machakann/vim-sandwich"
  -- "andymass/vim-matchup"
  -- "tpope/vim-unimpaired"
  --   \ "tpope/vim-repeat"
  -- "wellle/targets.vim"
  -- "numToStr/Comment.nvim"
  -- "AndrewRadev/splitjoin.vim"
  -- "junegunn/vim-easy-align"
  -- "phaazon/hop.nvim"

  -- completion
  -- editing
  -- git
  -- passive
  -- telescope
  -- tree-sitter
  -- ui

  -- Aesthetic
  use {
    "lukas-reineke/indent-blankline.nvim",
    config = function()
      local vim = vim
      vim.api.nvim_create_user_command("IB", "IndentBlanklineToggle", {})
      vim.g.indentLine_char = '┊'
    end,
  }
  use "psliwka/vim-smoothie"
  use "folke/lsp-colors.nvim"

  -- Themes
  use "nanotech/jellybeans.vim" -- "highlight WinSeparator guifg=None"
  use { "dracula/vim", as = "dracula" }
  use "sainnhe/sonokai"
  use "sainnhe/edge"
  use "folke/tokyonight.nvim"
  use "Michal-Miko/vim-mono-red"
  use "vim-scripts/greenvision"

  -- Misc
  use "johngrib/vim-game-code-break"
  use "junegunn/goyo.vim"
  use "junegunn/limelight.vim"

end

local compile_path = util.join_paths(
  vim.fn.stdpath('config'), "plugin", "packer_compiled.lua"
)

local config = {
  compile_path = compile_path,
  display = {
    open_fn = function()
      return util.float({ border = "shadow" })
    end,
  },
  profile = { enable = true, threshold = 0 },
}

packer.startup({ spec, config = config })

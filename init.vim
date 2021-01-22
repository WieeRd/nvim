set langmenu=en_US
let $LANG = 'en_US'

let $vimrc = '$XDG_CONFIG_HOME/nvim/init.vim'
let $plugin = '$XDG_CONFIG_HOME/nvim/plugin.vim'
source $plugin

set noundofile
set noswapfile
set encoding=UTF-8

set t_Co=256
set termguicolors
colorscheme dracula

inoremap kj <Esc>
tnoremap kj <C-\><C-n>
noremap <C-l> :noh<CR><C-l>

nnoremap <S-tab> :NERDTreeToggle<CR>
command NCD NERDTreeCWD
command NFD NERDTreeFind

set number
set nowrap
set wildmenu

set hlsearch
set incsearch

set clipboard=unnamedplus
set mouse=c

set tabstop=4
set shiftwidth=4

set smartindent
set autoindent

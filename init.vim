set langmenu=en_US
set encoding=UTF-8
let $LANG = 'en_US'

" export XDG_CONFIG_HOME=~/.config
let $vimrc = '$XDG_CONFIG_HOME/nvim/init.vim'
let $plugin = '$XDG_CONFIG_HOME/nvim/plugin.vim'
source $plugin

set noundofile
set noswapfile

set t_Co=256
set termguicolors
colo sonokai

" Esc alternative
inoremap kj <Esc>
tnoremap kj <C-\><C-n>

" use arrow keys for scrolling
nnoremap <Up> <C-y>
nnoremap <Down> <C-e>

nnoremap <C-l> :noh<CR><C-l>
nnoremap <C-s> :w<CR>

" Use alt + hjkl to resize windows
nnoremap <M-j>    :resize -1<CR>
nnoremap <M-k>    :resize +1<CR>
nnoremap <M-h>    :vertical resize -1<CR>
nnoremap <M-l>    :vertical resize +1<CR>

" Save & Load session
command SV mks! ~/.vimlast
command LD so ~/.vimlast
noremap <F1> :wqa<CR>
noremap <F2> :SV<CR>
noremap <F3> :LD<CR>

" Settings I forgot what it means
set hidden
set updatetime=200
set shortmess+=c
set scrolloff=5

set laststatus=1
set signcolumn=no
set number
set nowrap
" set cursorline

set wildmenu
set pumheight=10

set hlsearch
set incsearch
set ignorecase
set smartcase

set clipboard=unnamedplus
set mouse=c

set tabstop=4
set expandtab
set shiftwidth=4

set smartindent
set autoindent

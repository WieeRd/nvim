set langmenu=en_US
set encoding=UTF-8
let $LANG = 'en_US'

let $dotvim = expand('<sfile>:p:h') " $XDG_CONFIG_HOME/nvim
let $vimrc = $dotvim .. '/init.vim'
let $plugin = $dotvim .. '/plugin.vim'
source $plugin

set noundofile
set noswapfile

set clipboard=unnamedplus
set mouse=c

set termguicolors
colo sonokai

" Esc alternative
inoremap kj <Esc>
tnoremap kj <C-\><C-n>

" Up/Down arrow keys for scrolling
" by doing this, mouse wheel scroll page without moving cursor
nnoremap <Up> <C-y>
nnoremap <Down> <C-e>

" Right/Left arrow keys for navigating tab pages
" TODO: find better use of these keys
noremap <Left> gt
noremap <Right> gT

" clear search highlights when redrawing screen with Ctrl+L
nnoremap <C-l> :noh<CR><C-l>
" I keep using Ctrl+S unconsciously even when using vim haha
nnoremap <C-s> :w<CR>

" use alt + hjkl to resize windows
nnoremap <silent> <M-j> :resize -1<CR>
nnoremap <silent> <M-k> :resize +1<CR>
nnoremap <silent> <M-h> :vertical resize -1<CR>
nnoremap <silent> <M-l> :vertical resize +1<CR>

" quit after saving current session and all files
noremap <silent> <F2> :mksession! ~/Session.vim <bar> wqa<CR>
" continue where I left off
noremap <silent> <F3> :source ~/Session.vim<CR><C-l>

" settings I forgot what it means
set hidden
set updatetime=200
set shortmess+=c

" visual settings
set laststatus=1
set signcolumn=no
set number
set nowrap
set nocursorline
set scrolloff=5
set wildmenu
set pumheight=10

" searching settings
set hlsearch
set incsearch
set ignorecase
set smartcase

" tab/indentation settings
set tabstop=4
set shiftwidth=0
set noexpandtab

filetype plugin indent on
set autoindent
" set smartindent
set cindent

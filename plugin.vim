call plug#begin('$XDG_CONFIG_HOME/nvim/plugged')
" Syntax
Plug 'bfrg/vim-cpp-modern'
Plug 'vim-python/python-syntax'

" Tools
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'Yggdroot/indentLine'
Plug 'Raimondi/delimitMate'

" IDE
Plug 'ctrlpvim/ctrlp.vim'
Plug 'preservim/nerdtree' |
            \ Plug 'Xuyuanp/nerdtree-git-plugin' |
            \ Plug 'ryanoasis/vim-devicons'
Plug 'tpope/vim-fugitive'
Plug 'yuttie/comfortable-motion.vim'

" Themes
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'mhartington/oceanic-next'
Plug 'vim-scripts/greenvision'
Plug 'Michal-Miko/vim-mono-red'
Plug 'nanotech/jellybeans.vim'
Plug 'ayu-theme/ayu-vim'
Plug 'relastle/bluewery.vim'
Plug 'Mizux/vim-colorschemes'

" Misc
Plug 'johngrib/vim-game-code-break'

call plug#end()

" IndentLine config
autocmd VimEnter * if bufname('%') == '' | IndentLinesDisable | endif
let g:indentLine_char = '┊'
let g:indentLine_showFirstIndentLevel = 1
let g:indentLine_first_char = '┊' 

" CtrlP config
set wildignore+=*/tmp/*,*.so,*.swp,*.zip     " MacOSX/Linux
set wildignore+=*\\tmp\\*,*.swp,*.zip,*.exe  " Windows

" NERDTree config
let NERDTreeShowHidden=1
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() |
    \ quit | endif
let g:NERDTreeGitStatusUseNerdFonts = 1

let ayucolor="mirage"
let g:oceanic_next_terminal_bold = 1
let g:oceanic_next_terminal_italic = 1

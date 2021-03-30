call plug#begin('$XDG_CONFIG_HOME/nvim/plugged')
" Syntax
Plug 'octol/vim-cpp-enhanced-highlight'
" Plug 'bfrg/vim-cpp-modern'
Plug 'vim-python/python-syntax'

" Tools
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-unimpaired'

Plug 'Raimondi/delimitMate'
Plug 'Yggdroot/indentLine'
Plug 'jeetsukumaran/vim-pythonsense'

" IDE
Plug 'ctrlpvim/ctrlp.vim'
Plug 'preservim/nerdtree' |
           \ Plug 'Xuyuanp/nerdtree-git-plugin' |
           \ Plug 'ryanoasis/vim-devicons'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Themes
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'mhartington/oceanic-next'
Plug 'vim-scripts/greenvision'
Plug 'Michal-Miko/vim-mono-red'
Plug 'nanotech/jellybeans.vim'
Plug 'ayu-theme/ayu-vim'
Plug 'relastle/bluewery.vim'
Plug 'Mizux/vim-colorschemes'
Plug 'ciaranm/inkpot'

" Misc
Plug 'johngrib/vim-game-code-break'

call plug#end()

" cpp syntax config
let g:cpp_class_scope_highlight = 1
let g:cpp_member_variable_highlight = 1
let g:cpp_class_decl_highlight = 1
let g:cpp_posix_standard = 1
let g:cpp_experimental_template_highlight = 1
let g:cpp_concepts_highlight = 1
let c_no_curly_error=1

" python syntax
let g:python_highlight_all = 1
let g:is_pythonsense_suppress_motion_keymaps = 1

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
" let g:NERDTreeGitStatusUseNerdFonts = 1
nnoremap <S-tab> :NERDTreeToggle<CR>
command NCD NERDTreeCWD
command NFD NERDTreeFind

" GitGutter
command GS GitGutterSignsEnable | set signcolumn=yes:1
command GH GitGutterSignsDisable | set signcolumn=no
nmap ]h <Plug>(GitGutterNextHunk)
nmap [h <Plug>(GitGutterPrevHunk)

" coc.nvim
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Enter to select first
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

nnoremap <silent> K :call <SID>show_documentation()<CR>
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" colorschemes
let ayucolor="mirage"
let g:oceanic_next_terminal_bold = 1
let g:oceanic_next_terminal_italic = 1

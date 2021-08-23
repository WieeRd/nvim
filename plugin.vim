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
" Plug 'lukas-reineke/indent-blankline.nvim'
Plug 'jeetsukumaran/vim-pythonsense'

" IDE-like
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'ctrlpvim/ctrlp.vim'
Plug 'preservim/nerdtree' |
           \ Plug 'Xuyuanp/nerdtree-git-plugin' |
           \ Plug 'ryanoasis/vim-devicons'
" Plug 'bluz71/vim-moonfly-statusline'

" Git
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
Plug 'junegunn/gv.vim'

" Themes
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'mhartington/oceanic-next'
Plug 'sainnhe/sonokai'
Plug 'arcticicestudio/nord-vim'
Plug 'nanotech/jellybeans.vim'
Plug 'junegunn/seoul256.vim'
Plug 'Michal-Miko/vim-mono-red'
Plug 'vim-scripts/greenvision'

" Misc
Plug 'johngrib/vim-game-code-break'
Plug 'junegunn/goyo.vim'
Plug 'junegunn/limelight.vim'

call plug#end()

" cpp syntax
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

" IndentLine
autocmd VimEnter * if bufname('%') == '' | IndentLinesDisable | endif
let g:indentLine_char = '┊'
let g:indentLine_showFirstIndentLevel = 1
let g:indentLine_first_char = '┊' 

" CtrlP
set wildignore+=*/tmp/*,*.so,*.swp,*.zip     " MacOSX/Linux
set wildignore+=*\\tmp\\*,*.swp,*.zip,*.exe  " Windows

" NERDTree
let NERDTreeShowHidden=1
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() |
    \ quit | endif
" let g:NERDTreeGitStatusUseNerdFonts = 1
nnoremap <S-tab> :NERDTreeToggle<CR>
command NT NERDTreeToggle
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

" Enter to select first match
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" K to show documentation
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

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" colorscheme
let g:oceanic_next_terminal_bold = 1
let g:oceanic_next_terminal_italic = 1

let g:sonokai_style='default'

" Goyo
map <F4> :Goyo<CR><C-l>
let g:goyo_width="45%"
let g:goyo_height="90%"
let s:scrolloff_modified=float2nr(winheight(0)*0.9*0.33)

function! s:goyo_enter()
  let s:scrolloff_default = &scrolloff
  let &scrolloff=s:scrolloff_modified
  set noshowmode
  set nocursorline
  augroup cmdline
    autocmd CmdlineLeave : echo ''
  augroup END
  IndentLinesDisable
  Limelight
endfunction

function! s:goyo_leave()
  let &scrolloff=s:scrolloff_default
  set showmode
  set cursorline
  autocmd! cmdline
  IndentLinesEnable
  Limelight!
endfunction

autocmd! User GoyoEnter nested call <SID>goyo_enter()
autocmd! User GoyoLeave nested call <SID>goyo_leave()

" moonfly
let g:moonflyIgnoreDefaultColors = 1

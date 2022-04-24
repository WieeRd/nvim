" Esc alternative
inoremap kj <Esc>
" tnoremap kj <C-\><C-n>

" Scrolling
nnoremap <Up> <C-y>
nnoremap <Down> <C-e>
nnoremap <ScrollWheelUp> <C-y>
nnoremap <ScrollWheelDown> <C-e>

" Left/Right arrow keys for navigating tab pages
noremap <Left> gt
noremap <Right> gT

" Clear search highlights when redrawing screen with Ctrl+L
nnoremap <C-l> :noh<CR><C-l>
" I keep using Ctrl+S unconsciously even when using vim
nnoremap <C-s> :w<CR>

" ALT + hjkl to resize windows
nnoremap <silent> <M-j> :resize -1<CR>
nnoremap <silent> <M-k> :resize +1<CR>
nnoremap <silent> <M-h> :vertical resize -1<CR>
nnoremap <silent> <M-l> :vertical resize +1<CR>

" quit after saving current session and all files
noremap <silent> <F2> :mksession! ~/Session.vim <bar> wqa<CR>
" continue where I left off
noremap <silent> <F3> :source ~/Session.vim<CR><C-l>

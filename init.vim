" always set to '~/.config/nvim'; not portable
" let $dotvim = stdpath('config')

let $dotvim = expand('<sfile>:p:h')
let $vimrc = $dotvim .. '/init.vim'

let $option = $dotvim .. '/options.vim'
let $keymap = $dotvim .. '/keymaps.vim'
let $plugin = $dotvim .. '/plugins.vim'

source $plugin
source $option
source $keymap

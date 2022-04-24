let $dotvim = stdpath('config') " ~/.config/nvim
let $vimrc = $dotvim .. '/init.vim'

let $option = $dotvim .. '/options.vim'
let $keymap = $dotvim .. '/keymaps.vim'
let $plugin = $dotvim .. '/plugins.vim'

source $plugin
source $option
source $keymap

" this file will run after loading each colorscheme,
" overriding highlight groups of every colorscheme.
" see `lua/custom/autocmds.lua`

" distinguishable highlight for current search result
highlight link CurSearch IncSearch

" LSP document highlight
highlight! link LspReferenceRead CursorLine  " symbol references
highlight! link LspReferenceWrite CursorLine  " symbol definition
highlight! clear LspReferenceText  " matching keywords and stuffs

" vim-illuminate: sync with LspReference
highlight! link IlluminatedWordRead LspReferenceRead
highlight! link IlluminatedWordWrite LspReferenceWrite
highlight! link IlluminatedWordText LspReferenceText

" gitsigns.nvim: virtual text blame highlight
highlight default link GitSignsCurrentLineBlame CursorLine

" nnn.nvim
highlight! link NnnBorder FloatBorder
highlight! link NnnNormal NormalFloat
highlight! link NnnNormalNC NormalFloat

" nvim-dap-virtual-text
highlight! link NvimDapVirtualText DiagnosticInfo
highlight! link NvimDapVirtualTextChanged DiagnosticVirtualTextWarn
highlight! link NvimDapVirtualTextError DiagnosticVirtualTextError

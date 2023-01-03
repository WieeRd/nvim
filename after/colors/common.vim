" symbol references
highlight! link LspReferenceRead CursorLine
highlight! link IlluminatedWordRead CursorLine

" symbol definition
highlight default link LspReferenceWrite CursorLine
highlight default link IlluminatedWordWrite CursorLine

" matching keywords and stuffs
highlight! link LspReferenceText NONE
highlight! link IlluminatedWordText NONE

" distinguishable highlight for current search result
highlight link CurSearch IncSearch

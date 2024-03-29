" dark tabline
highlight! link TabLineFill TabLine 

" more significant current search
highlight! link CurSearch IncSearch

" distinguish doc comments from regular comments
highlight! link @comment.documentation @operator

" background highlights for virtual text diagnostics
" guibg values taken from tokyonight; somehow fits very well
highlight DiagnosticVirtualTextHint  guifg=#6a9589 guibg=#1a2b32
highlight DiagnosticVirtualTextInfo  guifg=#658594 guibg=#192b38
highlight DiagnosticVirtualTextWarn  guifg=#ff9e3b guibg=#2e2a2d
highlight DiagnosticVirtualTextError guifg=#e82424 guibg=#2d202a

" Telescope hl group overrides
highlight! link TelescopeTitle Folded

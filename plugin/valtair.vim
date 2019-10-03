if exists('g:loaded_valtair')
    finish
endif
let g:loaded_valtair = 1

command! Valtair call valtair#main(<q-args>)

highlight default ValtairTailActive guifg=#334152 guibg=#a8d2eb
highlight default ValtairTailInactive guifg=#334152 guibg=#aaaaaa

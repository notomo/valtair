if exists('g:loaded_valtair')
    finish
endif
let g:loaded_valtair = 1

command! -nargs=* Valtair call valtair#main(<q-args>)
command! -nargs=* ValtairDo call valtair#do(<q-args>)

highlight default ValtairTailActive guifg=#334152 guibg=#a8d2eb
highlight default ValtairTailInactive guifg=#334152 guibg=#aaaaaa

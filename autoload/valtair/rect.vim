
function! valtair#rect#new(width, height) abort
    let rect = {
        \ 'width': a:width,
        \ 'height': a:height,
    \ }

    return rect
endfunction

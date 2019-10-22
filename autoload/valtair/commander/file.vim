
function! valtair#commander#file#new() abort
    let file = {
    \ }

    function! file.open(value) abort
        execute 'edit' a:value
    endfunction

    return file
endfunction

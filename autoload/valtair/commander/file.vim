
function! valtair#commander#file#new() abort
    let file = {
    \ }

    function! file.open(target) abort
        execute 'edit' a:target.value
    endfunction

    return file
endfunction

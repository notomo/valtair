
function! valtair#messenger#clear() abort
    let f = {}
    function! f.default(message) abort
        echo a:message
    endfunction

    let s:func = { message -> f.default(message) }
endfunction

call valtair#messenger#clear()


function! valtair#messenger#set_func(func) abort
    let s:func = { message -> a:func(message) }
endfunction

function! valtair#messenger#new() abort
    let messenger = {
        \ 'func': s:func,
    \ }

    function! messenger.warn(message) abort
        echohl WarningMsg
        call self.func('[valtair] ' . a:message)
        echohl None
    endfunction

    function! messenger.error(message) abort
        echohl ErrorMsg
        call self.func('[valtair] ' . a:message)
        echohl None
    endfunction

    return messenger
endfunction

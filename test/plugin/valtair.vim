
let s:suite = themis#suite('plugin.valtair')
let s:assert = themis#helper('assert')

function! s:suite.before_each()
    call ValtairTestBeforeEach()
endfunction

function! s:suite.after_each()
    call ValtairTestAfterEach()
endfunction

function! s:count_window() abort
    return tabpagewinnr(tabpagenr(), '$')
endfunction

function! s:sync_main() abort
    let command = valtair#main('')
    call command.wait()
    return command
endfunction

function! s:suite.main()
    call s:sync_main()

    call s:assert.true(s:count_window() > 2)
endfunction

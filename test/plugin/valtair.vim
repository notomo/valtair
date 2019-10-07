
let s:suite = themis#suite('plugin.valtair')
let s:assert = themis#helper('assert')

function! s:suite.before_each()
    call ValtairTestBeforeEach()
    filetype on
    syntax enable
endfunction

function! s:suite.after_each()
    call ValtairTestAfterEach()
    filetype off
    syntax off
endfunction

function! s:count_window() abort
    return tabpagewinnr(tabpagenr(), '$')
endfunction

function! s:sync_main(args) abort
    let command = valtair#main(a:args)
    call command.wait()
    return command
endfunction

function! s:suite.main()
    call s:sync_main('-collector-cmd=ls\ -1')

    call s:assert.true(s:count_window() > 2)
    call s:assert.equals(&filetype, 'valtair')
endfunction

function! ValtairTest() abort
    return ['hoge', 'foo']
endfunction

function! s:suite.func()
    call s:sync_main('-collector=func -collector-func=ValtairTest')

    call s:assert.equals(s:count_window(), 3)
endfunction

function! s:suite.excmd_escaped()
    call s:sync_main('-collector=excmd -collector-cmd=echomsg\ "hoge"')

    call s:assert.equals(s:count_window(), 2)
endfunction

command! ValtairTest call s:echomsg()
function! s:echomsg() abort
    echomsg 'hoge'
    echomsg 'foo'
    echomsg 'bar'
endfunction

function! s:suite.excmd()
    call s:sync_main('-collector=excmd -collector-cmd=ValtairTest')

    call s:assert.equals(s:count_window(), 4)
endfunction

function! s:suite.nop_logger()
    call valtair#logger#clear()

    call s:sync_main('-collector-cmd=ls')
endfunction

function! s:suite.quit()
    call s:sync_main('-collector=func -collector-func=ValtairTest')
    call s:assert.equals(s:count_window(), 3)

    ValtairDo quit
    call s:assert.equals(s:count_window(), 1)
endfunction

function! s:suite.cursor_moved()
    call s:sync_main('-collector=func -collector-func=ValtairTest')
    call s:assert.equals(s:count_window(), 3)

    let line_number = line('.')

    normal! G
    doautocmd CursorMoved

    call s:assert.equals(line('.'), line_number)
endfunction

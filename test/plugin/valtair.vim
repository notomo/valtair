
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

function! s:line() abort
    return getline(line('.'))
endfunction

function! s:assert.contains(haystack, needle) abort
    call s:assert.true(count(a:haystack, a:needle) != 0, a:needle . ' must be in the haystack, but actual: ' . a:haystack)
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

    ValtairDo quit
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

function! s:suite.next_prev()
    call s:sync_main('-collector=excmd -collector-cmd=ValtairTest')
    call s:assert.equals(s:count_window(), 4)
    call s:assert.contains(s:line(), 'hoge')

    ValtairDo next
    call s:assert.contains(s:line(), 'foo')

    ValtairDo next
    call s:assert.contains(s:line(), 'bar')

    ValtairDo next
    call s:assert.contains(s:line(), 'hoge')

    ValtairDo prev
    call s:assert.contains(s:line(), 'bar')

    ValtairDo prev
    call s:assert.contains(s:line(), 'foo')

    ValtairDo prev
    call s:assert.contains(s:line(), 'hoge')
endfunction

command! ValtairMultiColumnTest call s:many_echomsg()
function! s:many_echomsg() abort
    echomsg '0'
    echomsg '1'
    echomsg '2'
    echomsg '3'
    echomsg '4'
    echomsg '5'
    echomsg '6'
    echomsg '7'
    echomsg '8'
    echomsg '9'
    echomsg '10'
    echomsg '11'
endfunction

function! s:suite.left_right()
    call s:sync_main('-collector=excmd -collector-cmd=ValtairMultiColumnTest')
    call s:assert.equals(s:count_window(), 13)
    call s:assert.contains(s:line(), '0')

    ValtairDo next
    call s:assert.contains(s:line(), '1')

    ValtairDo right
    call s:assert.contains(s:line(), '6')

    ValtairDo right
    call s:assert.contains(s:line(), '11')

    ValtairDo right
    call s:assert.contains(s:line(), '1')

    ValtairDo next
    call s:assert.contains(s:line(), '2')
    ValtairDo next
    call s:assert.contains(s:line(), '3')

    ValtairDo right
    call s:assert.contains(s:line(), '8')

    ValtairDo right
    call s:assert.contains(s:line(), '3')

    ValtairDo prev
    call s:assert.contains(s:line(), '2')
    ValtairDo prev
    call s:assert.contains(s:line(), '1')

    ValtairDo left
    call s:assert.contains(s:line(), '11')

    ValtairDo left
    call s:assert.contains(s:line(), '6')

    ValtairDo left
    call s:assert.contains(s:line(), '1')

    ValtairDo next
    call s:assert.contains(s:line(), '2')

    ValtairDo left
    call s:assert.contains(s:line(), '7')
endfunction

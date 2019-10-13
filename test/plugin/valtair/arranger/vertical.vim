
let s:suite = themis#suite('plugin.valtair.arranger.vertical')
let s:assert = themis#helper('assert')

function! s:suite.before_each()
    call ValtairTestBeforeEach(s:assert)
    filetype on
    syntax enable
endfunction

function! s:suite.after_each()
    call ValtairTestAfterEach()
    filetype off
    syntax off
endfunction

command! ValtairVerticalTest call s:test()
function! s:test() abort
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

function! s:suite.vertical()
    let command = valtair#main('-collector=excmd -collector-cmd=ValtairVerticalTest')
    call command.wait()

    call s:assert.window_count(13)
    call s:assert.contains_line('0')

    ValtairDo left
    call s:assert.contains_line('9')

    ValtairDo right
    call s:assert.contains_line('0')

    ValtairDo next
    call s:assert.contains_line('1')

    ValtairDo right
    call s:assert.contains_line('6')

    ValtairDo right
    call s:assert.contains_line('11')

    ValtairDo right
    call s:assert.contains_line('2')

    ValtairDo next
    call s:assert.contains_line('3')

    ValtairDo right
    call s:assert.contains_line('8')

    ValtairDo right
    call s:assert.contains_line('4')

    ValtairDo left
    call s:assert.contains_line('8')

    ValtairDo left
    call s:assert.contains_line('3')

    ValtairDo left
    call s:assert.contains_line('7')
endfunction

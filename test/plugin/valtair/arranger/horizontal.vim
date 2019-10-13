
let s:suite = themis#suite('plugin.valtair.arranger.horizontal')
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

command! ValtairHorizontalTest call s:test()
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
    echomsg '12'
    echomsg '13'
endfunction

function! s:suite.horizontal()
    let command = valtair#main('-collector=excmd -collector-cmd=ValtairHorizontalTest --arranger=horizontal')
    call command.wait()

    call s:assert.window_count(15)
    call s:assert.contains_line('0')

    ValtairDo right
    call s:assert.contains_line('1')

    ValtairDo right
    call s:assert.contains_line('2')

    ValtairDo left
    call s:assert.contains_line('1')

    ValtairDo left
    call s:assert.contains_line('0')

    ValtairDo left
    call s:assert.contains_line('13')

    ValtairDo right
    call s:assert.contains_line('0')

    ValtairDo down
    call s:assert.contains_line('6')

    ValtairDo down
    call s:assert.contains_line('12')

    ValtairDo down
    call s:assert.contains_line('1')

    ValtairDo up
    call s:assert.contains_line('12')

    ValtairDo up
    call s:assert.contains_line('6')

    ValtairDo up
    call s:assert.contains_line('0')

    ValtairDo up
    call s:assert.contains_line('11')
endfunction


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

function! s:suite.right_left()
    let command = valtair#main('-collector=excmd -collector-cmd=ValtairVerticalTest')
    call command.wait()

    call s:assert.window_count(13)
    call s:assert.contains_line('0')

    ValtairDo right
    call s:assert.contains_line('5')

    ValtairDo left
    call s:assert.contains_line('0')
endfunction

function! s:suite.wrap_right()
    let command = valtair#main('-collector=excmd -collector-cmd=ValtairVerticalTest')
    call command.wait()

    call s:assert.contains_line('0')

    ValtairDo right
    ValtairDo right
    call s:assert.contains_line('10')

    ValtairDo right
    call s:assert.contains_line('1')
endfunction

function! s:suite.wrap_left()
    let command = valtair#main('-collector=excmd -collector-cmd=ValtairVerticalTest')
    call command.wait()

    call s:assert.contains_line('0')

    ValtairDo down
    call s:assert.contains_line('1')

    ValtairDo left
    call s:assert.contains_line('10')
endfunction

function! s:suite.wrap_wrap_left_right()
    let command = valtair#main('-collector=excmd -collector-cmd=ValtairVerticalTest')
    call command.wait()

    call s:assert.contains_line('0')

    ValtairDo left
    call s:assert.contains_line('9')

    ValtairDo right
    call s:assert.contains_line('0')
endfunction

function! s:suite.down_up()
    let command = valtair#main('-collector=excmd -collector-cmd=ValtairVerticalTest')
    call command.wait()

    call s:assert.contains_line('0')

    ValtairDo down
    call s:assert.contains_line('1')

    ValtairDo up
    call s:assert.contains_line('0')
endfunction

function! s:suite.wrap_down()
    let command = valtair#main('-collector=excmd -collector-cmd=ValtairVerticalTest')
    call command.wait()

    call s:assert.contains_line('0')

    ValtairDo down
    ValtairDo down
    ValtairDo down
    ValtairDo down
    call s:assert.contains_line('4')

    ValtairDo down
    call s:assert.contains_line('5')
endfunction

function! s:suite.wrap_up()
    let command = valtair#main('-collector=excmd -collector-cmd=ValtairVerticalTest')
    call command.wait()

    call s:assert.contains_line('0')

    ValtairDo right
    call s:assert.contains_line('5')

    ValtairDo up
    call s:assert.contains_line('4')
endfunction

function! s:suite.wrap_wrap_up_down()
    let command = valtair#main('-collector=excmd -collector-cmd=ValtairVerticalTest')
    call command.wait()

    call s:assert.contains_line('0')

    ValtairDo up
    call s:assert.contains_line('11')

    ValtairDo down
    call s:assert.contains_line('0')
endfunction

function! s:suite.first()
    let command = valtair#main('-collector=excmd -collector-cmd=ValtairVerticalTest')
    call command.wait()

    call s:assert.contains_line('0')

    ValtairDo first
    call s:assert.contains_line('0')

    ValtairDo right
    call s:assert.contains_line('5')

    ValtairDo first
    call s:assert.contains_line('0')

    ValtairDo right
    call s:assert.contains_line('5')
endfunction

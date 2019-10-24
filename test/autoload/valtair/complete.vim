
let s:suite = themis#suite('autoload.valtair.complete')
let s:assert = themis#helper('assert')

function! s:suite.before_each()
    call ValtairTestBeforeEach(s:assert)
endfunction

function! s:suite.after_each()
    call ValtairTestAfterEach()
endfunction

let s:_cursor_position = 8888

function! s:suite.not_started()
    let got = valtair#complete#do('', 'ValtairDo ', s:_cursor_position)
    let names = split(got, "\n")

    call s:assert.empty(names)
endfunction

function! s:suite.do()
    let command = valtair#main('-collector-cmd=ls\ -1')
    call command.wait()

    let got = valtair#complete#do('', 'ValtairDo ', s:_cursor_position)
    let names = split(got, "\n")

    call s:assert.contains(names, 'quit')
    call s:assert.contains(names, 'open')
endfunction

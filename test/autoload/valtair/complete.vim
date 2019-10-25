
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

function! s:suite.main()
    let got = valtair#complete#main('', 'Valtair ', s:_cursor_position)
    let names = split(got, "\n")

    call s:assert.contains(names, '-collector=')
    call s:assert.contains(names, '-arranger=')
    call s:assert.contains(names, '-arranger-width=')
    call s:assert.contains(names, '-arranger-max-row=')
endfunction

function! s:suite.arranger()
    let got = valtair#complete#main('-arranger=', 'Valtair -arranger=', s:_cursor_position)
    let names = split(got, "\n")

    call s:assert.contains(names, '-arranger=vertical')
endfunction

function! s:suite.collector()
    let got = valtair#complete#main('-collector=', 'Valtair -collector=', s:_cursor_position)
    let names = split(got, "\n")

    call s:assert.contains(names, '-collector=excmd')
endfunction

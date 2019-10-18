
let s:suite = themis#suite('autoload.valtair.option')
let s:assert = themis#helper('assert')

function! s:suite.before_each()
    call ValtairTestBeforeEach(s:assert)
endfunction

function! s:suite.after_each()
    call ValtairTestAfterEach()
endfunction

function! s:suite.parse()
    let [options, err] = valtair#option#parse('-collector-cmd=ls\ -1')

    call s:assert.empty(err)
    call s:assert.equals(options.collector.name, 'cmd')
    call s:assert.equals(options.collector.options.cmd, 'ls\ -1')
endfunction

function! s:suite.parse_escaped()
    let [options, err] = valtair#option#parse('-collector=cmd -collector-cmd=ls\\ -collector-cd=.')

    call s:assert.empty(err)
    call s:assert.equals(options.collector.name, 'cmd')
    call s:assert.equals(options.collector.options.cmd, 'ls\')
endfunction

function! s:suite.row_padding()
    let [options, err] = valtair#option#parse('-arranger-row-padding=3')

    call s:assert.empty(err)
    call s:assert.equals(options.arranger.options.row_padding, 3)
endfunction

function! s:suite.invalid_row_padding()
    let [options, err] = valtair#option#parse('-arranger-row-padding=-1')

    call themis#log('[test messanger] ' . err)
    call s:assert.not_empty(err)
endfunction

function! s:suite.invalid_width()
    let [options, err] = valtair#option#parse('-arranger-width=0')

    call themis#log('[test messanger] ' . err)
    call s:assert.not_empty(err)
endfunction

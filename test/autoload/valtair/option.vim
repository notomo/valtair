
let s:suite = themis#suite('autoload.valtair.option')
let s:assert = themis#helper('assert')

function! s:suite.before_each()
    call ValtairTestBeforeEach()
endfunction

function! s:suite.after_each()
    call ValtairTestAfterEach()
endfunction

function! s:suite.parse()
    let options = valtair#option#parse('-collector-cmd=ls\ -1')

    call s:assert.equals(options.collector.name, 'cmd')
    call s:assert.equals(options.collector.options.cmd, 'ls\ -1')
endfunction

function! s:suite.parse_escaped()
    let options = valtair#option#parse('-collector=cmd -collector-cmd=ls\\ -collector-cd=.')

    call s:assert.equals(options.collector.name, 'cmd')
    call s:assert.equals(options.collector.options.cmd, 'ls\')
endfunction
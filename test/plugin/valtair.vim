
let s:suite = themis#suite('plugin.valtair')
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

function! s:sync_main(args) abort
    let command = valtair#main(a:args)
    call command.wait()
    return command
endfunction


function! s:suite.cmd()
    call s:sync_main('-collector-cmd=ls\ -1')

    call s:assert.equals(&filetype, 'valtair')
endfunction


function! ValtairFuncTest() abort
    return ['hoge', 'foo']
endfunction

function! s:suite.func()
    call s:sync_main('-collector=func -collector-func=ValtairFuncTest')

    call s:assert.window_count(3)
endfunction


command! ValtairExcommandTest call s:excommand()
function! s:excommand() abort
    echomsg 'hoge'
    echomsg 'foo'
    echomsg 'bar'
endfunction

function! s:suite.excmd()
    call s:sync_main('-collector=excmd -collector-cmd=ValtairExcommandTest')

    call s:assert.window_count(4)
endfunction

function! s:suite.excmd_escaped()
    call s:sync_main('-collector=excmd -collector-cmd=echomsg\ "hoge"')

    call s:assert.window_count(2)
endfunction


function! s:suite.nop_logger()
    call valtair#logger#clear()

    call s:sync_main('-collector-cmd=ls')

    ValtairDo quit
endfunction


command! ValtairQuitTest call s:quit()
function! s:quit() abort
    echomsg 'hoge'
    echomsg 'foo'
    echomsg 'bar'
endfunction

function! s:suite.quit()
    call s:sync_main('-collector=excmd -collector-cmd=ValtairQuitTest')
    call s:assert.window_count(4)

    ValtairDo quit
    call s:assert.window_count(1)
endfunction


command! ValtairCursorMovedTest call s:cursor()
function! s:cursor() abort
    echomsg 'hoge'
    echomsg 'foo'
    echomsg 'bar'
endfunction

function! s:suite.cursor_moved()
    call s:sync_main('-collector=excmd -collector-cmd=ValtairCursorMovedTest')
    call s:assert.window_count(4)

    let line_number = line('.')

    normal! G
    doautocmd CursorMoved

    call s:assert.equals(line('.'), line_number)
endfunction


function! s:suite.not_started()
    let f = {'called': v:false}
    function! f.echo(message) abort
        call valtair#logger#new('output').log(': ' . a:message)
        let self.called = v:true
    endfunction
    call valtair#messenger#set_func({ msg -> f.echo(msg) })

    ValtairDo next

    call s:assert.true(f.called)
endfunction

command! ValtairNotFoundTest call s:not_found()
function! s:not_found() abort
    echomsg 'hoge'
endfunction

function! s:suite.not_found_action()
    call s:sync_main('-collector=excmd -collector-cmd=ValtairNotFoundTest')

    let f = {'called': v:false}
    function! f.echo(message) abort
        call valtair#logger#new('output').log(': ' . a:message)
        let self.called = v:true
    endfunction
    call valtair#messenger#set_func({ msg -> f.echo(msg) })

    ValtairDo invalid

    call s:assert.true(f.called)
endfunction


function! ValtairMultipleTest() abort
    return ['hoge', 'foo', 'bar']
endfunction

function! s:suite.execute_multiple()
    call s:sync_main('-collector=func -collector-func=ValtairMultipleTest')
    call s:assert.window_count(4)

    ValtairDo down
    call s:assert.contains_line('foo')

    call s:sync_main('-collector=func -collector-func=ValtairMultipleTest')
    call s:assert.window_count(4)

    ValtairDo down
    call s:assert.contains_line('foo')
endfunction

function! s:suite.open()
    cd test/plugin/_test_data/open
    call s:sync_main('-collector-cmd=ls\ -1')

    call s:assert.window_count(3)

    ValtairDo down
    call s:assert.contains_line('opened')

    ValtairDo open

    call s:assert.file_name('opened')
    call s:assert.window_count(1)
    call s:assert.contains_line('opened_file')
endfunction

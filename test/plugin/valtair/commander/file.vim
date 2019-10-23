
let s:suite = themis#suite('plugin.valtair.commander.file')
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

function! s:suite.open()
    cd test/plugin/_test_data/open
    let command = valtair#main('-collector-cmd=ls\ -1')
    call command.wait()

    call s:assert.window_count(3)

    ValtairDo down
    call s:assert.contains_line('opened')

    ValtairDo open

    call s:assert.file_name('opened')
    call s:assert.window_count(1)
    call s:assert.contains_line('opened_file')
endfunction

function! s:suite.tabopen()
    cd test/plugin/_test_data/open
    let command = valtair#main('-collector-cmd=ls\ -1')
    call command.wait()

    call s:assert.window_count(3)

    ValtairDo down
    call s:assert.contains_line('opened')

    ValtairDo tabopen

    call s:assert.file_name('opened')
    call s:assert.window_count(1)
    call s:assert.tab_count(2)
    call s:assert.contains_line('opened_file')

    tabprevious
    call s:assert.window_count(1)
endfunction

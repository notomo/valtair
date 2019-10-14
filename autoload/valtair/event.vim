
let s:JOB_FINISHED = 'ValtairJobFinished'
let s:COLLECTOR_FINISHED = 'ValtairCollectorFinished'
let s:WINDOW_CURSOR_MOVED = 'ValtairWindowCursorMoved'

let s:callbacks = {}
let s:buffer_callbacks = {}

function! valtair#event#service() abort
    let service = {
        \ 'logger': valtair#logger#new('event'),
    \ }

    function! service.on_job_finished(id, callback) abort
        call self._on_event(s:JOB_FINISHED, a:id, a:callback, v:true)
    endfunction

    function! service.on_collector_finished(id, callback) abort
        call self._on_event(s:COLLECTOR_FINISHED, a:id, a:callback, v:true)
    endfunction

    function! service.on_buffer_wiped(bufnr, callback) abort
        call self._on_buffer_event('BufWipeout', a:bufnr, a:callback)
    endfunction

    function! service._on_buffer_event(event_name, bufnr, callback) abort
        let buffer_event_name = self._buffer_event_name(a:event_name, a:bufnr)
        let s:buffer_callbacks[buffer_event_name] = a:callback
        execute printf('autocmd %s <buffer=%s> call s:buffer_callback("%s", %s)', a:event_name, a:bufnr, buffer_event_name, a:bufnr)
    endfunction

    function! service.on_moved_window_cursor(id, callback, bufnr) abort
        call self._buffer_group_event(s:WINDOW_CURSOR_MOVED, a:id, a:callback, a:bufnr)
    endfunction

    function! service._buffer_group_event(event_name, id, callback, bufnr) abort
        let group_name = self._buffer_event_name(a:event_name, a:bufnr)
        execute 'augroup' group_name
            call self._on_event(group_name, a:id, a:callback, v:false)
        execute 'augroup END'
    endfunction

    function! service._buffer_event_name(event_name, bufnr) abort
        return printf('%s_%s', a:event_name, a:bufnr)
    endfunction

    function! service.fix_window_cursor(bufnr) abort
        execute printf('autocmd CursorMoved <buffer=%s> ++nested call valtair#event#service().window_cursor_moved(%s)', a:bufnr, a:bufnr)

        let event_name = self._buffer_event_name(s:WINDOW_CURSOR_MOVED, a:bufnr)
        execute printf('autocmd BufWipeout <buffer=%s> call s:clean_group("%s")', a:bufnr, event_name)
    endfunction

    function! service._on_event(event_name, id, callback, once) abort
        if !has_key(s:callbacks, a:event_name)
            let s:callbacks[a:event_name] = {}
        endif
        let s:callbacks[a:event_name][a:id] = a:callback
        if a:once
            let once = '++once'
        else
            let once = ''
        endif

        execute printf('autocmd User %s:%s ++nested %s call s:callback(expand("<amatch>"), "%s", %s)', a:event_name, a:id, once, a:event_name, a:once)
    endfunction

    function! service.job_finished(id) abort
        call self._emit(s:JOB_FINISHED, a:id)
    endfunction

    function! service.collector_finished(id) abort
        call self._emit(s:COLLECTOR_FINISHED, a:id)
    endfunction

    function! service.window_cursor_moved(bufnr) abort
        let id = win_getid()
        let event_name = self._buffer_event_name(s:WINDOW_CURSOR_MOVED, a:bufnr)
        call self._emit(event_name, id)
    endfunction

    function! service._emit(event_name, id) abort
        let event = printf('%s:%s', a:event_name, a:id)
        call self.logger.log(event)
        execute printf('doautocmd User %s', event)
    endfunction

    return service
endfunction

function! s:callback(amatch, event_name, once) abort
    let [_, id] = split(a:amatch, a:event_name . ':', 'keep')
    call s:callbacks[a:event_name][id](id)

    if a:once
        call remove(s:callbacks[a:event_name], id)
    endif
endfunction

function! s:buffer_callback(buffer_event_name, bufnr) abort
    call s:buffer_callbacks[a:buffer_event_name](a:bufnr)
    call remove(s:buffer_callbacks, a:buffer_event_name)
endfunction

function! s:clean_group(group_name) abort
    execute 'autocmd!' . a:group_name
    call remove(s:callbacks, a:group_name)
endfunction

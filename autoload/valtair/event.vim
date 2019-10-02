
let s:JOB_FINISHED = 'ValrairJobFinished'
let s:COLLECTOR_FINISHED = 'ValrairCollectorFinished'

let s:callbacks = {}

function! valtair#event#service() abort
    let service = {
        \ 'logger': valtair#logger#new('event'),
    \ }

    function! service.on_job_finished(id, callback) abort
        call self._on_event(s:JOB_FINISHED, a:id, a:callback)
    endfunction

    function! service.on_collector_finished(id, callback) abort
        call self._on_event(s:COLLECTOR_FINISHED, a:id, a:callback)
    endfunction

    function! service._on_event(event_name, id, callback) abort
        if !has_key(s:callbacks, a:event_name)
            let s:callbacks[a:event_name] = {}
        endif
        let s:callbacks[a:event_name][a:id] = a:callback
        execute printf('autocmd User %s:%s ++nested ++once call s:callback(expand("<amatch>"), "%s")', a:event_name, a:id, a:event_name)
    endfunction

    function! service.job_finished(id) abort
        call self._emit(s:JOB_FINISHED, a:id)
    endfunction

    function! service.collector_finished(id) abort
        call self._emit(s:COLLECTOR_FINISHED, a:id)
    endfunction

    function! service._emit(event_name, id) abort
        let event = printf('%s:%s', a:event_name, a:id)
        call self.logger.log(event)
        execute printf('doautocmd User %s', event)
    endfunction

    return service
endfunction

function! s:callback(amatch, event_name) abort
    let [_, id] = split(a:amatch, a:event_name . ':', 'keep')
    call s:callbacks[a:event_name][id](id)

    call remove(s:callbacks[a:event_name], id)
endfunction

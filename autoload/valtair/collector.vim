
let s:id = 0

function! valtair#collector#new(event_service, impl) abort
    let s:id += 1

    let collector = {
        \ 'id': s:id,
        \ 'event_service': a:event_service,
        \ 'impl': a:impl,
        \ 'texts': [],
    \ }

    function! collector.start() abort
        if !has_key(self.impl, 'job')
            let self.texts = self.impl.texts()
            call self.event_service.collector_finished(self.id)
            return
        endif

        let job = self.impl.job
        call self.event_service.on_job_finished(job.id, { id -> self.on_job_finished(id) })
        call job.start()
    endfunction

    function! collector.on_job_finished(id) abort
        let self.texts = self.impl.texts()
        call self.event_service.collector_finished(self.id)
    endfunction

    function! collector.wait(timeout_msec) abort
        if !has_key(self.impl, 'job')
            return
        endif
        call self.impl.job.wait(a:timeout_msec)
    endfunction

    return collector
endfunction

let s:directory = expand('<sfile>:p:h') . '/collector'

function! valtair#collector#get_impl(event_service, collector_options) abort
    let name = a:collector_options.name
    let path = printf('%s/%s.vim', s:directory, name)
    if !filereadable(path)
        throw printf('collector not found: %s', name)
    endif

    let func = printf('valtair#collector#%s#new', name)
    return call(func, [a:event_service, a:collector_options.options])
endfunction

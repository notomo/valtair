
let s:id = 0

function! valtair#collector#new(event_service, impl) abort
    let s:id += 1

    let collector = {
        \ 'id': s:id,
        \ 'event_service': a:event_service,
        \ 'impl': a:impl,
        \ 'targets': [],
    \ }

    function! collector.start() abort
        if !has_key(self.impl, 'job')
            let self.targets = self.impl.targets()
            call self.event_service.collector_finished(self.id)
            return
        endif

        let job = self.impl.job
        call self.event_service.on_job_finished(job.id, { id -> self.on_job_finished(id) })
        call job.start()
    endfunction

    function! collector.on_job_finished(id) abort
        let self.targets = self.impl.targets()
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

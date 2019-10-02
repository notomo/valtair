
let s:id = 0

function! valtair#collector#new(event_service) abort
    let s:id += 1

    let collector = {
        \ 'id': s:id,
        \ 'job': valtair#job#new(['ls', '-1'], a:event_service),
        \ 'event_service': a:event_service,
        \ 'items': [],
    \ }

    function! collector.start() abort
        call self.event_service.on_job_finished(self.job.id, { id -> self.on_job_finished(id) })
        call self.job.start()
    endfunction

    function! collector.on_job_finished(id) abort
        let self.items = self.job.stdout
        call self.event_service.collector_finished(self.id)
    endfunction

    function! collector.wait(timeout_msec) abort
        call self.job.wait(a:timeout_msec)
    endfunction

    return collector
endfunction

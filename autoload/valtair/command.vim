
function! valtair#command#new(collector, arranger, event_service) abort
    let command = {
        \ 'collector': a:collector,
        \ 'arranger': a:arranger,
        \ 'event_service': a:event_service,
    \ }

    function! command.start() abort
        call self.event_service.on_collector_finished(self.collector.id, { id -> self.on_collector_finished(id) })
        call self.collector.start()
    endfunction

    function! command.on_collector_finished(id) abort
        let targets = self.collector.targets
        call self.arranger.open_tiles(targets)
    endfunction

    function! command.wait() abort
        call self.collector.wait(100)
    endfunction

    return command
endfunction

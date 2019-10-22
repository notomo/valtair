
function! valtair#collector#cmd#new(event_service, options) abort
    if has_key(a:options, 'cmd')
        let cmd = split(a:options.cmd, '\v\\\s')
    else
        let cmd = ['ls', '-1']
    endif

    let collector = {
        \ 'job': valtair#job#new(cmd, a:event_service),
    \ }

    function! collector.targets() abort
        return map(self.job.stdout, { _, v -> {'type': 'file', 'value': v}})
    endfunction

    return collector
endfunction

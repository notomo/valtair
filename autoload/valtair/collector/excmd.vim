
function! valtair#collector#excmd#new(event_service, options) abort
    let collector = {
        \ 'cmd': join(split(a:options.cmd, '\v\\\s'), ' '),
        \ 'logger': valtair#logger#new('collector.cmd'),
    \ }

    function! collector.items() abort
        let output = execute(self.cmd)
        let items = split(output, "\n")
        call self.logger.label('items').logs(items)
        return items
    endfunction

    return collector
endfunction

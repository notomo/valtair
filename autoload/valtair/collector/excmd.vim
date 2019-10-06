
function! valtair#collector#excmd#new(event_service, options) abort
    let collector = {
        \ 'cmd': join(split(a:options.cmd, '\v\\\s'), ' '),
        \ 'logger': valtair#logger#new('collector.cmd'),
    \ }

    function! collector.texts() abort
        let output = execute(self.cmd)
        let texts = split(output, "\n")
        call self.logger.label('texts').logs(texts)
        return texts
    endfunction

    return collector
endfunction


function! valtair#collector#func#new(event_service, options) abort
    let collector = {
        \ 'func': a:options.func,
        \ 'logger': valtair#logger#new('collector.func'),
    \ }

    function! collector.targets() abort
        let texts = call(self.func, [])
        call self.logger.label('texts').logs(texts)
        return map(texts, { _, v -> {'type': 'word', 'value': v}})
    endfunction

    return collector
endfunction

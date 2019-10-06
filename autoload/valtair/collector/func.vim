
function! valtair#collector#func#new(event_service, options) abort
    let collector = {
        \ 'func': a:options.func,
        \ 'logger': valtair#logger#new('collector.func'),
    \ }

    function! collector.texts() abort
        let texts = call(self.func, [])
        call self.logger.label('texts').logs(texts)
        return texts
    endfunction

    return collector
endfunction

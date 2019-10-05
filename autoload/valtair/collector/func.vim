
function! valtair#collector#func#new(event_service, options) abort
    let collector = {
        \ 'func': a:options.func,
        \ 'logger': valtair#logger#new('collector.func'),
    \ }

    function! collector.items() abort
        let items = call(self.func, [])
        call self.logger.label('items').logs(items)
        return items
    endfunction

    return collector
endfunction

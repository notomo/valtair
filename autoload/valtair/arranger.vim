
function! valtair#arranger#new(event_service, impl) abort
    let arranger = {
        \ 'tiles': [],
        \ 'impl': a:impl,
        \ 'event_service': a:event_service,
        \ 'current': 0,
        \ 'logger': valtair#logger#new('arranger'),
    \ }

    function! arranger.open_tiles(texts) abort
        let buffer = valtair#buffer#new(self.event_service, a:texts, self.impl.padding)
        let items = self.impl.items(buffer.line_numbers)
        if empty(items)
            return
        endif

        let self.tiles = map(items, { _, item -> valtair#tile#new(self.event_service, item, buffer.bufnr) })
        for tile in self.tiles
            call tile.open()
        endfor

        call buffer.fix_cursor()

        call self.tiles[0].enter()
        let self.current = 0
    endfunction

    function! arranger.enter_next() abort
        let index = (self.current + 1) % len(self.tiles)
        call self.tiles[index].enter()
        let self.current = index
    endfunction

    function! arranger.enter_prev() abort
        let index = (self.current - 1) % len(self.tiles)
        call self.tiles[index].enter()
        let self.current = index
    endfunction

    function! arranger.enter_right() abort
        let index = self.impl.right(self.current, len(self.tiles))
        call self.tiles[index].enter()
        let self.current = index
    endfunction

    function! arranger.enter_left() abort
        let index = self.impl.left(self.current, len(self.tiles))
        call self.tiles[index].enter()
        let self.current = index
    endfunction

    function! arranger.close() abort
        for tile in self.tiles
            call tile.close()
        endfor
        let self.tiles = []
        let self.current = 0
    endfunction

    return arranger
endfunction

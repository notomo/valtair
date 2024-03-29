
function! valtair#tiles#new(event_service, buffer) abort
    let tiles = {
        \ '_event_service': a:event_service,
        \ '_buffer': a:buffer,
        \ '_tiles': [],
        \ '_offset': {
            \ 'x': 0,
            \ 'y': 0,
        \ },
        \ 'logger': valtair#logger#new('tiles'),
    \ }

    function! tiles.enter(index) abort
        let next_tile = self._tiles[a:index]
        if !next_tile.displayed_all(self._offset)
            let self._offset = next_tile.offset()
        endif

        call self._buffer.wipe_on_hidden(v:false)
        for tile in self._tiles
            call tile.open(self._offset)
        endfor
        call self._buffer.wipe_on_hidden(v:true)

        call next_tile.enter()
    endfunction

    function! tiles.open(items) abort
        let self._tiles = map(a:items, { _, item -> valtair#tile#new(self._event_service, item, self._buffer.bufnr) })
        for tile in self._tiles
            call tile.open(self._offset)
        endfor
    endfunction

    function! tiles.clear() abort
        let self._tiles = []
        let self._offset.x = 0
        let self._offset.y = 0
    endfunction

    function! tiles.target(index) abort
        let tile = self._tiles[a:index]
        return tile.target
    endfunction

    return tiles
endfunction

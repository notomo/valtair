
function! valtair#tiles#new(event_service, buffer) abort
    let tiles = {
        \ '_event_service': a:event_service,
        \ '_buffer': a:buffer,
        \ '_tiles': [],
        \ '_offset': {
            \ 'x': 0,
            \ 'y': 0,
        \ }
    \ }

    function! tiles.enter(index) abort
        let next_tile = self._tiles[a:index]
        if !next_tile.displayed_all(self._offset)
            let self._offset.x = max([next_tile.x + next_tile.width - &columns + 1, 0])
            let self._offset.y = max([next_tile.y + next_tile.height - (&lines - &cmdheight) + 1, 0])
        endif

        call self._buffer.wipe_on_hidden(v:false)
        for tile in self._tiles
            call tile.open(self._offset)
        endfor
        call self._buffer.wipe_on_hidden(v:true)

        call next_tile.enter()
    endfunction

    function! tiles.open(items, bufnr) abort
        let bufnr = a:bufnr
        let self._tiles = map(a:items, { _, item -> valtair#tile#new(self._event_service, item, bufnr) })
        for tile in self._tiles
            call tile.open(self._offset)
        endfor
    endfunction

    function! tiles.clear() abort
        let self._tiles = []
        let self._offset.x = 0
        let self._offset.y = 0
    endfunction

    return tiles
endfunction

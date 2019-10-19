
function! valtair#tiles#new(event_service) abort
    let tiles = {
        \ '_event_service': a:event_service,
        \ '_tiles': [],
    \ }

    function! tiles.enter(index) abort
        call self._tiles[a:index].enter()
    endfunction

    function! tiles.open(items, bufnr) abort
        let bufnr = a:bufnr
        let self._tiles = map(a:items, { _, item -> valtair#tile#new(self._event_service, item, bufnr) })
        for tile in self._tiles
            call tile.open()
        endfor
    endfunction

    function! tiles.clear() abort
        let self._tiles = []
    endfunction

    return tiles
endfunction


function! valtair#arranger#new() abort
    let arranger = {
        \ 'tiles': [],
    \ }

    function! arranger.open_tiles(items) abort
        if empty(a:items)
            return
        endif
        let self.tiles = map(copy(a:items), { _, item -> valtair#tile#new(item) })

        let row = 1
        let col = &columns / 2
        for tile in self.tiles
            call tile.open(row, col)
            let row += 4
        endfor
        call self.tiles[0].enter()
    endfunction

    return arranger
endfunction

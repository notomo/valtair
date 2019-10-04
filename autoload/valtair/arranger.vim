
function! valtair#arranger#new() abort
    let arranger = {
        \ 'tiles': [],
        \ 'current': 0,
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
        let self.current = 0
    endfunction

    function! arranger.enter_next() abort
        if empty(self.tiles)
            return
        endif

        if self.current + 1 >= len(self.tiles)
            call self.tiles[0].enter()
            let self.current = 0
            return
        endif

        let index = self.current + 1
        call self.tiles[index].enter()
        let self.current = index
    endfunction

    function! arranger.enter_prev() abort
        if empty(self.tiles)
            return
        endif

        if self.current - 1 < 0
            let index = len(self.tiles) - 1
            call self.tiles[index].enter()
            let self.current = index
            return
        endif

        let index = self.current - 1
        call self.tiles[index].enter()
        let self.current = index
    endfunction

    return arranger
endfunction

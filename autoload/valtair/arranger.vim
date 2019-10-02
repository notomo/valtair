
function! valtair#arranger#new() abort
    let arranger = {}

    function! arranger.open_tiles(items) abort
        let tiles = map(copy(a:items), { _, item -> valtair#tile#new(item) })

        let row = 1
        let col = &columns / 2
        for tile in tiles
            call tile.open(row, col)
            let row += 4
        endfor
    endfunction

    return arranger
endfunction

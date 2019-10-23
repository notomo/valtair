
function! valtair#tile#new(event_service, item, bufnr) abort
    let tile = {
        \ 'target': a:item.target,
        \ '_event_service': a:event_service,
        \ '_bufnr': a:bufnr,
        \ '_window': valtair#window#new(a:event_service, a:bufnr, a:item.target.line_number),
        \ '_x': a:item.x,
        \ '_y': a:item.y,
        \ '_width': a:item.rect.width,
        \ '_height': a:item.rect.height,
        \ '_index': a:item.index,
    \ }

    function! tile.open(offset) abort
        let row = self._y - a:offset.y
        let lines = &lines - &cmdheight - 1
        if lines < row || row + self._height < 0
            return self._window.close()
        endif

        let col = self._x - a:offset.x
        let columns = &columns - 1
        if columns < col || col + self._width < 0
            return self._window.close()
        endif

        let height = self._height
        if row <= lines && row + self._height - 1 > lines
            let height = lines - row + 1
        elseif row < 0
            let height = self._height + row
        endif

        let width = self._width
        if col <= columns && col + self._width - 1 > columns
            let width = columns - col + 1
        elseif col < 0
            let width = self._width + col
        endif

        return self._window.open(row, col, width, height, { id -> self._on_enter() })
    endfunction

    function! tile.enter() abort
        call self._window.enter()
    endfunction

    function! tile._on_enter() abort
        call self._window.reset_option()
        call self._event_service.tile_entered(self._bufnr, self._index)
    endfunction

    function! tile.displayed_all(offset) abort
        if self._window.closed()
            return v:false
        endif

        let col = self._x - a:offset.x
        if col < 0 || col + self._width - 1 > &columns - 1
            return v:false
        endif

        let row = self._y - a:offset.y
        if row < 0 || row + self._height - 1 > &lines - &cmdheight - 1
            return v:false
        endif

        return v:true
    endfunction

    function! tile.offset() abort
        let x = max([self._x + self._width - &columns + 1, 0])
        let y = max([self._y + self._height - (&lines - &cmdheight) + 1, 0])
        return {'x': x, 'y': y}
    endfunction

    return tile
endfunction

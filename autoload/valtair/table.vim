
function! valtair#table#editor(cell_rect, margin) abort
    let table = {
        \ 'rect': a:cell_rect,
        \ '_margin': a:margin,
        \ '_cells': [],
        \ '_row_count': 0,
        \ 'logger': valtair#logger#new('table'),
    \ }

    let lines = &lines - &cmdheight
    let table['_max_row_count'] = lines / (table.rect.height + table._margin)
    call table.logger.log('max row count: ' . table._max_row_count)

    let columns = &columns
    let table['_max_column_count'] = columns / (table.rect.width + table._margin)
    call table.logger.log('max column count: ' . table._max_column_count)

    function! table.make_cells_vertically(contents) abort
        let cells = map(range(self._max_column_count), { _k, _v -> [] })
        let index = 0
        for content in a:contents
            let col_index = index / self._max_row_count
            if col_index >= self._max_column_count
                break
            endif
            let row_index = index % self._max_row_count

            let cell = {
                \ 'content': content,
                \ 'index': index,
                \ 'x': (self.rect.width + self._margin) * col_index + 1,
                \ 'y': (self.rect.height + self._margin) * row_index + 1,
            \ }
            call add(cells[col_index], cell)

            let index += 1
        endfor

        call self._set_cells(cells)

        return cells
    endfunction

    function! table._set_cells(cells) abort
        let cell_count = 0
        for rows in a:cells
            let cell_count += len(rows)
        endfor
        call self.logger.log('cell count: ' . cell_count)

        let self._row_count = cell_count >= self._max_row_count ? self._max_row_count : cell_count
        call self.logger.log('row count: ' . self._row_count)

        let self._cells = filter(a:cells, { _, v -> !empty(v) })
        call self.logger.label('cells').logs(self._cells)
    endfunction

    function! table.wrap_right(current_index) abort
        let current = self._current(a:current_index)

        let column = (current.column + 1) % len(self._cells)
        if len(self._cells[column]) <= current.row
            let column = 0
        endif
        call self.logger.log('right column: ' . column)

        return self._cells[column][current.row].index
    endfunction

    function! table.wrap_left(current_index) abort
        let current = self._current(a:current_index)

        let column = (current.column - 1) % len(self._cells)
        if len(self._cells[column]) <= current.row
            let column = len(self._cells[column]) - 1
        endif
        call self.logger.log('left column: ' . column)

        return self._cells[column][current.row].index
    endfunction

    function! table._current(current_index) abort
        call self.logger.log('current index: ' . a:current_index)

        let current_column = 0
        let index = 0
        for rows in self._cells
            let index += len(rows)
            if index > a:current_index
                break
            endif
            let current_column += 1
        endfor

        let current_row = a:current_index - current_column * self._row_count

        let current = {
            \ 'column': current_column,
            \ 'row': current_row,
        \ }
        call self.logger.label('current').log(current)
        return current
    endfunction

    return table
endfunction

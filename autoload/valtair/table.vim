
function! valtair#table#editor(cell_rect, margin) abort
    let table = {
        \ 'rect': a:cell_rect,
        \ '_margin': a:margin,
        \ '_cells': [],
        \ '_row_count': 0,
        \ '_cell_count': 0,
        \ '_last_cell': v:null,
        \ '_current': {
            \ 'row': 0,
            \ 'column': 0,
        \ },
        \ 'logger': valtair#logger#new('table'),
    \ }

    function! table.make_cells_vertically(contents, max_row_count) abort
        let lines = &lines - &cmdheight
        let max_row_count = !empty(a:max_row_count) ? a:max_row_count : lines / (self.rect.height + self._margin)
        call self.logger.log('max row count: ' . max_row_count)

        if max_row_count == 0
            return []
        endif
        let column_number = float2nr(ceil(str2float(len(a:contents)) / max_row_count))
        let cells = map(range(column_number), { _k, _v -> [] })

        let index = 0
        let cell = {}
        for content in a:contents
            let col_index = index / max_row_count
            let row_index = index % max_row_count

            let cell = {
                \ 'content': content,
                \ 'index': index,
                \ 'col_index': col_index,
                \ 'row_index': row_index,
                \ 'x': (self.rect.width + self._margin) * col_index,
                \ 'y': (self.rect.height + self._margin) * row_index,
            \ }
            call add(cells[col_index], cell)

            let index += 1
        endfor

        if empty(cell)
            return []
        endif
        call self._set_cells(cells, cell)

        return cells
    endfunction

    function! table.make_cells_horizontally(contents, max_column_count) abort
        let max_column_count = !empty(a:max_column_count) ? a:max_column_count : &columns / (self.rect.width + self._margin)
        call self.logger.log('max column count: ' . max_column_count)

        if max_column_count == 0
            return []
        endif
        let cells = map(range(max_column_count), { _k, _v -> [] })

        let index = 0
        let cell = {}
        for content in a:contents
            let row_index = index / max_column_count
            let col_index = index % max_column_count

            let cell = {
                \ 'content': content,
                \ 'index': index,
                \ 'col_index': col_index,
                \ 'row_index': row_index,
                \ 'x': (self.rect.width + self._margin) * col_index,
                \ 'y': (self.rect.height + self._margin) * row_index,
            \ }
            call add(cells[col_index], cell)

            let index += 1
        endfor

        if empty(cell)
            return []
        endif
        call self._set_cells(cells, cell)

        return cells
    endfunction

    function! table._set_cells(cells, last_cell) abort
        let self._cell_count = 0
        for rows in a:cells
            let self._cell_count += len(rows)
        endfor
        call self.logger.log('cell count: ' . self._cell_count)

        let self._row_count = max(map(copy(a:cells), { _, rows -> len(rows)}))
        call self.logger.log('row count: ' . self._row_count)

        let self._cells = filter(a:cells, { _, v -> !empty(v) })
        call self.logger.label('cells').logs(self._cells)

        let self._last_cell = a:last_cell
    endfunction

    function! table.wrap_right() abort
        let current = self._get_current()

        let column = (current.column + 1) % len(self._cells)
        let row = current.row
        if current.column + 1 >= len(self._cells) || current.row >= len(self._cells[column])
            let column = 0
            let row = current.row + 1 >= len(self._cells[column]) ? 0 : current.row + 1
        endif

        call self._set_current(row, column)
        return self._cells[column][row].index
    endfunction

    function! table.wrap_left() abort
        let current = self._get_current()

        let column = current.column - 1
        let row = current.row
        if column < 0
            let column = len(self._cells) - 1
            let row = current.row - 1
        endif
        if row < 0
            let last = filter(copy(self._cells), { _, rows -> len(rows) == self._row_count })[-1][-1]
            let column = last.col_index
            let row = last.row_index
        endif
        if len(self._cells[column]) <= row
            let column = column - 1
        endif

        call self._set_current(row, column)
        return self._cells[column][row].index
    endfunction

    function! table.wrap_down() abort
        let current = self._get_current()

        let column = current.column
        let row = (current.row + 1) % len(self._cells[current.column])
        if current.row + 1 >= len(self._cells[current.column])
            let column = current.column + 1 >= len(self._cells) ? 0 : current.column + 1
        endif

        call self._set_current(row, column)
        return self._cells[column][row].index
    endfunction

    function! table.wrap_up() abort
        let current = self._get_current()

        let column = current.column
        let row = (current.row - 1) % len(self._cells[current.column])
        if len(self._cells[current.column]) <= current.row
            let column = (current.column - 1) % len(self._cells)
        endif

        let row = current.row - 1
        let column = current.column
        if row < 0
            let column = current.column - 1
            let row = len(self._cells[column]) - 1
        endif
        if column < 0
            let column = len(self._cells) - 1
        endif
        if row >= len(self._cells[column])
            let row = row - 1
        endif

        call self._set_current(row, column)
        return self._cells[column][row].index
    endfunction

    function! table.first() abort
        call self._set_current(0, 0)
        let current = self._get_current()

        return self._cells[current.column][current.row].index
    endfunction

    function! table.last() abort
        let last = self._last_cell
        let row = last.row_index
        let column = last.col_index
        call self._set_current(row, column)

        return self._cells[column][row].index
    endfunction

    function! table._get_current() abort
        call self.logger.label('get current').log(self._current)
        return self._current
    endfunction

    function! table._set_current(row, column) abort
        let self._current.row = a:row
        let self._current.column = a:column
        call self.logger.label('set current').log(self._current)
    endfunction

    return table
endfunction

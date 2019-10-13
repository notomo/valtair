
function! valtair#table#editor(cell_rect, margin) abort
    let table = {
        \ 'rect': a:cell_rect,
        \ '_margin': a:margin,
        \ '_cells': [],
        \ '_row_count': 0,
        \ '_column_count': 0,
        \ 'logger': valtair#logger#new('table'),
    \ }

    let lines = &lines - &cmdheight
    let table['_max_row_count'] = lines / (table.rect.height + table._margin)
    call table.logger.log('max row count: ' . table._max_row_count)

    let columns = &columns
    let table['_max_column_count'] = columns / (table.rect.width + table._margin)
    call table.logger.log('max column count: ' . table._max_column_count)

    function! table.make_vertical_cells(contents) abort
        let cells = []
        let i = 0
        for content in a:contents
            let col_index = i / self._max_row_count
            if col_index >= self._max_column_count
                break
            endif

            let cell = {
                \ 'content': content,
                \ 'x': (self.rect.width + self._margin) * col_index + 1,
                \ 'y': (self.rect.height + self._margin) * (i % self._max_row_count) + 1,
            \ }

            call add(cells, cell)
            let i += 1
        endfor

        call self._set_cells(cells)

        return cells
    endfunction

    function! table._set_cells(cells) abort
        let self._cells = a:cells

        let cell_count = len(a:cells)
        call self.logger.log('cell count: ' . cell_count)

        let self._row_count = cell_count >= self._max_row_count ? self._max_row_count : cell_count
        call self.logger.log('row count: ' . self._row_count)

        let remain = cell_count % self._max_row_count
        let self._column_count = cell_count / self._max_row_count + (remain > 0 ? 1 : 0)
        call self.logger.log('column count: ' . self._column_count)
    endfunction

    function! table.wrap_right(current_index) abort
        let index = (a:current_index + self._row_count) % (self._row_count * self._column_count)
        if index >= len(self._cells)
            return index - ((self._column_count - 1) * self._row_count)
        endif

        return index
    endfunction

    function! table.wrap_left(current_index) abort
        let index = (a:current_index - self._row_count) % (self._row_count * self._column_count)
        if index < 0
            let index = index + self._row_count * self._column_count
        endif
        if index >= len(self._cells)
            return index - self._row_count
        endif

        return index
    endfunction

    return table
endfunction

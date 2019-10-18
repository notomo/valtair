
function! valtair#arranger#vertical#new(options) abort
    let width = a:options.width
    let row_padding = a:options.row_padding
    let padding = valtair#padding#new(row_padding).with_width(width)
    let rect = valtair#rect#new(width, padding.height)
    let margin = 1

    let arranger = {
        \ 'logger': valtair#logger#new('arranger.vertical'),
        \ 'padding': padding,
        \ '_table': valtair#table#editor(rect, margin),
    \ }

    function! arranger.items(line_numbers) abort
        let items = []
        for rows in self._table.make_cells_vertically(a:line_numbers)
            for cell in rows
                let item = {
                    \ 'rect': self._table.rect,
                    \ 'line_number': cell.content,
                    \ 'x': cell.x,
                    \ 'y': cell.y,
                \ }
                call self.logger.label('item').log(item)

                call add(items, item)
            endfor
        endfor

        return items
    endfunction

    function! arranger.first() abort
        return self._table.first()
    endfunction

    function! arranger.last() abort
        return self._table.last()
    endfunction

    function! arranger.next() abort
        return self.down()
    endfunction

    function! arranger.prev() abort
        return self.up()
    endfunction

    function! arranger.up() abort
        return self._table.wrap_up()
    endfunction

    function! arranger.down() abort
        return self._table.wrap_down()
    endfunction

    function! arranger.right() abort
        return self._table.wrap_right()
    endfunction

    function! arranger.left() abort
        return self._table.wrap_left()
    endfunction

    return arranger
endfunction

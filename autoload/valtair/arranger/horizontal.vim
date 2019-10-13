
function! valtair#arranger#horizontal#new(options) abort
    let width = 30
    let top_bottom = 1
    let padding = valtair#padding#new(top_bottom).with_width(width)
    let rect = valtair#rect#new(width, padding.height)
    let margin = 1

    let arranger = {
        \ 'logger': valtair#logger#new('arranger.horizontal'),
        \ 'padding': padding,
        \ '_table': valtair#table#editor(rect, margin),
    \ }

    function! arranger.items(line_numbers) abort
        let items = []
        for rows in self._table.make_cells_horizontally(a:line_numbers)
            for cell in rows
                let item = {
                    \ 'rect': self._table.rect,
                    \ '_index': cell.index,
                    \ 'line_number': cell.content,
                    \ 'x': cell.x,
                    \ 'y': cell.y,
                \ }

                call add(items, item)
            endfor
        endfor

        call sort(items, { a, b -> a._index > b._index })
        call self.logger.label('item').logs(items)

        return items
    endfunction

    function! arranger.next() abort
        return self.right()
    endfunction

    function! arranger.prev() abort
        return self.left()
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


function! valtair#arranger#vertical#new(options) abort
    let width = 30
    let top_bottom = 1
    let padding = valtair#padding#new(top_bottom).with_width(width)
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

    function! arranger.right(current_index) abort
        return self._table.wrap_right(a:current_index)
    endfunction

    function! arranger.left(current_index) abort
        return self._table.wrap_left(a:current_index)
    endfunction

    return arranger
endfunction

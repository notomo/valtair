
function! valtair#arranger#horizontal#new(options) abort
    let width = a:options.width
    let row_padding = a:options.row_padding
    let padding = valtair#padding#new(row_padding).with_width(width)
    let rect = valtair#rect#new(width, padding.height)
    let margin = 1

    let arranger = {
        \ 'logger': valtair#logger#new('arranger.horizontal'),
        \ 'padding': padding,
        \ '_table': valtair#table#editor(rect, margin),
        \ '_max_column': a:options.max_column,
    \ }

    function! arranger.items(targets) abort
        let items = []
        for rows in self._table.make_cells_horizontally(a:targets, self._max_column)
            for cell in rows
                let item = {
                    \ 'rect': self._table.rect,
                    \ 'index': cell.index,
                    \ 'target': cell.content,
                    \ 'x': cell.x,
                    \ 'y': cell.y,
                \ }

                call add(items, item)
            endfor
        endfor

        call sort(items, { a, b -> a.index > b.index })
        call self.logger.label('item').logs(items)

        return items
    endfunction

    function! arranger.first() abort
        return self._table.first()
    endfunction

    function! arranger.last() abort
        return self._table.last()
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

    function! arranger.enter(index) abort
        call self._table.enter_horizontally(a:index)
    endfunction

    function! arranger.current() abort
        return self._table.current()
    endfunction

    return arranger
endfunction

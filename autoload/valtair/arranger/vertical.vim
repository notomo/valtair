
function! valtair#arranger#vertical#new(options) abort
    let width = 30
    let top_bottom = 1
    let padding = valtair#padding#new(top_bottom).with_width(width)

    let arranger = {
        \ 'logger': valtair#logger#new('arranger.vertical'),
        \ 'padding': padding,
        \ '_width': width,
        \ '_height': padding.height,
        \ '_gap': 1,
    \ }

    let lines = &lines - &cmdheight
    let arranger['_max_row_count'] = lines / (arranger._height + arranger._gap)
    let columns = &columns
    let arranger['_max_column_count'] = columns / (arranger._width + arranger._gap)

    function! arranger.items(line_numbers) abort
        let items = []
        let i = 0
        for line_number in a:line_numbers
            let col_index = i / self._max_row_count
            if col_index >= self._max_column_count
                break
            endif

            let item = {
                \ 'line_number': line_number,
                \ 'width': self._width,
                \ 'height': self._height,
                \ 'row': (self._height + self._gap) * (i % self._max_row_count) + 1,
                \ 'col': (self._width + self._gap) * col_index + 1,
            \ }
            call self.logger.label('item').log(item)

            call add(items, item)
            let i += 1
        endfor

        return items
    endfunction

    function! arranger.right(current, count) abort
        let row_count = a:count >= self._max_row_count ? self._max_row_count : a:count
        let remain = a:count % self._max_row_count
        let column_count = a:count / self._max_row_count + (remain > 0 ? 1 : 0)

        let index = (a:current + row_count) % (row_count * column_count)
        if index >= a:count
            return index - ((column_count - 1) * row_count)
        endif
        return index
    endfunction

    function! arranger.left(current, count) abort
        let row_count = a:count >= self._max_row_count ? self._max_row_count : a:count
        let remain = a:count % self._max_row_count
        let column_count = a:count / self._max_row_count + (remain > 0 ? 1 : 0)

        let index = (a:current - row_count) % (row_count * column_count)
        if index < 0
            let index = index + column_count * row_count
        endif
        if index >= a:count
            return index - row_count
        endif
        return index
    endfunction

    return arranger
endfunction

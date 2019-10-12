
function! valtair#arranger#vertical#new(options) abort
    let arranger = {
        \ 'width': 30,
        \ 'height': 3,
        \ 'gap': 1,
        \ 'logger': valtair#logger#new('arranger.vertical'),
    \ }
    let lines = &lines - &cmdheight
    let arranger['max_row_count'] = lines / (arranger.height + arranger.gap)
    let columns = &columns
    let arranger['max_column_count'] = columns / (arranger.width + arranger.gap)

    function! arranger.items(line_numbers) abort
        let items = []
        let i = 0
        for line_number in a:line_numbers
            let col_index = i / self.max_row_count
            if col_index >= self.max_column_count
                break
            endif

            let item = {
                \ 'line_number': line_number,
                \ 'width': self.width,
                \ 'height': self.height,
                \ 'row': (self.height + self.gap) * (i % self.max_row_count) + 1,
                \ 'col': (self.width + self.gap) * col_index + 1,
            \ }
            call self.logger.label('item').log(item)

            call add(items, item)
            let i += 1
        endfor

        return items
    endfunction

    function! arranger.right(current, count) abort
        let row_count = a:count >= self.max_row_count ? self.max_row_count : a:count
        let remain = a:count % self.max_row_count
        let column_count = a:count / self.max_row_count + (remain > 0 ? 1 : 0)

        let index = (a:current + row_count) % (row_count * column_count)
        if index >= a:count
            return index - ((column_count - 1) * row_count)
        endif
        return index
    endfunction

    function! arranger.left(current, count) abort
        let row_count = a:count >= self.max_row_count ? self.max_row_count : a:count
        let remain = a:count % self.max_row_count
        let column_count = a:count / self.max_row_count + (remain > 0 ? 1 : 0)

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


function! valtair#arranger#vertical#new(options) abort
    let arranger = {
        \ 'width': 30,
        \ 'height': 3,
        \ 'gap': 1,
        \ 'row_count': 0,
        \ 'max_row_count': 0,
        \ 'column_count': 0,
        \ 'max_column_count': 0,
        \ 'logger': valtair#logger#new('arranger.vertical'),
    \ }

    function! arranger.items(line_numbers) abort
        let lines = &lines - &cmdheight
        call self.logger.log('lines: ' . lines)

        let self.max_row_count = lines / (self.height + self.gap)
        call self.logger.log('max_row_count: ' . self.max_row_count)

        let columns = &columns
        call self.logger.log('columns: ' . columns)

        let self.max_column_count = columns / (self.width + self.gap)
        call self.logger.log('max_column_count: ' . self.max_column_count)

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

        let self.row_count = len(items) >= self.max_row_count ? self.max_row_count : len(items)
        call self.logger.log('row_count: ' . self.row_count)

        let remain = len(items) % self.max_row_count
        let self.column_count = len(items) / self.max_row_count + (remain > 0 ? 1 : 0)
        call self.logger.log('column_count: ' . self.column_count)

        return items
    endfunction

    return arranger
endfunction

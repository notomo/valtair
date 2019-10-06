
function! valtair#arranger#vertical#new(options) abort
    let arranger = {
        \ 'width': 30,
        \ 'height': 3,
        \ 'gap': 1,
        \ 'logger': valtair#logger#new('arranger.vertical'),
    \ }

    function! arranger.items(line_numbers) abort
        let lines = &lines - &cmdheight
        call self.logger.log('lines: ' . lines)

        let max_row = lines / (self.height + self.gap)
        call self.logger.log('max_row: ' . max_row)

        let items = []
        let i = 0
        for line_number in a:line_numbers
            let item = {
                \ 'line_number': line_number,
                \ 'width': self.width,
                \ 'height': self.height,
                \ 'row': (self.height + self.gap) * (i % max_row) + 1,
                \ 'col': (self.width + self.gap) * (i / max_row) + 1,
            \ }
            call self.logger.label('item').dict_log(item)

            call add(items, item)
            let i += 1
        endfor

        return items
    endfunction

    return arranger
endfunction

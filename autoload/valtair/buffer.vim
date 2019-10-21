
function! valtair#buffer#new(event_service, padding) abort
    let buffer = {
        \ 'logger': valtair#logger#new('buffer'),
        \ 'bufnr': nvim_create_buf(v:false, v:true),
        \ 'event_service': a:event_service,
        \ '_padding': a:padding,
    \ }
    call nvim_buf_set_option(buffer.bufnr, 'bufhidden', 'wipe')
    call nvim_buf_set_option(buffer.bufnr, 'filetype', 'valtair')

    function! buffer.get_line_numbers(texts) abort
        let line_numbers = []
        let lines = []
        for text in a:texts
            call extend(lines, self._padding.lines)

            call add(lines, self._padding.add_left(text))
            call add(line_numbers, len(lines))

            call extend(lines, self._padding.lines)
        endfor

        call nvim_buf_set_lines(self.bufnr, 0, -1, v:true, lines)
        call nvim_buf_set_option(self.bufnr, 'modifiable', v:false)

        return line_numbers
    endfunction

    function! buffer.fix_cursor() abort
        call self.event_service.fix_window_cursor(self.bufnr)
        call self.event_service.fix_window_options(self.bufnr)
    endfunction

    function! buffer.on_wiped(callback) abort
        call self.event_service.on_buffer_wiped(self.bufnr, a:callback)
    endfunction

    function! buffer.on_tile_entered(callback) abort
        call self.event_service.on_tile_entered(self.bufnr, a:callback)
    endfunction

    function! buffer.wipe() abort
        execute 'silent!' self.bufnr 'bwipeout!'
    endfunction

    return buffer
endfunction


function! valtair#buffer#new(event_service, texts, padding) abort
    let buffer = {
        \ 'logger': valtair#logger#new('buffer'),
        \ 'bufnr': nvim_create_buf(v:false, v:true),
        \ 'line_numbers': [],
        \ 'event_service': a:event_service,
    \ }

    let lines = []
    for text in a:texts
        call extend(lines, a:padding.lines)

        call add(lines, a:padding.add_left(text))
        call add(buffer.line_numbers, len(lines))

        call extend(lines, a:padding.lines)
    endfor

    call nvim_buf_set_lines(buffer.bufnr, 0, -1, v:true, lines)
    call nvim_buf_set_option(buffer.bufnr, 'modifiable', v:false)
    call nvim_buf_set_option(buffer.bufnr, 'filetype', 'valtair')
    call nvim_buf_set_option(buffer.bufnr, 'bufhidden', 'wipe')

    function! buffer.fix_cursor() abort
        call self.event_service.fix_window_cursor(self.bufnr)
    endfunction

    function! buffer.on_wiped(callback) abort
        call self.event_service.on_buffer_wiped(self.bufnr, a:callback)
    endfunction

    return buffer
endfunction

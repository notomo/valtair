
function! valtair#buffer#new(event_service, texts, tile_width, tile_height) abort
    let buffer = {
        \ 'logger': valtair#logger#new('buffer'),
        \ 'bufnr': nvim_create_buf(v:false, v:true),
        \ 'line_numbers': [],
        \ 'event_service': a:event_service,
    \ }

    let i = 0
    let lines = []
    let empty = split(repeat('_', float2nr(round(a:tile_height / 2)) - 1), '_', v:true)
    for text in a:texts
        let i += len(empty) + 1
        let space = repeat(' ', (a:tile_width - strlen(text)) / 2)
        call extend(lines, empty)
        call add(lines, space . text)
        call add(buffer.line_numbers, i)
    endfor
    call extend(lines, empty)

    call nvim_buf_set_lines(buffer.bufnr, 0, -1, v:true, lines)
    call nvim_buf_set_option(buffer.bufnr, 'modifiable', v:false)
    call nvim_buf_set_option(buffer.bufnr, 'filetype', 'valtair')
    call nvim_buf_set_option(buffer.bufnr, 'bufhidden', 'wipe')
    call nvim_buf_set_var(buffer.bufnr, '&scrolloff', 0)
    call nvim_buf_set_var(buffer.bufnr, '&sidescrolloff', 0)

    function! buffer.fix_cursor() abort
        call self.event_service.fix_window_cursor(self.bufnr)
    endfunction

    return buffer
endfunction


function! valtair#arranger#new(event_service, impl) abort
    let arranger = {
        \ 'tiles': [],
        \ 'impl': a:impl,
        \ 'event_service': a:event_service,
        \ 'current': 0,
        \ 'logger': valtair#logger#new('arranger'),
    \ }

    function! arranger.open_tiles(texts) abort
        let lines = []
        let line_numbers = []

        let i = 0
        let empty = split(repeat('_', float2nr(round(self.impl.height / 2)) - 1), '_', v:true)
        for text in a:texts
            let i += len(empty) + 1
            let space = repeat(' ', (self.impl.width - strlen(text)) / 2)
            call extend(lines, empty)
            call add(lines, space . text)
            call add(line_numbers, i)
        endfor
        call extend(lines, empty)

        let bufnr = nvim_create_buf(v:false, v:true)
        call nvim_buf_set_lines(bufnr, 0, -1, v:true, lines)
        call nvim_buf_set_option(bufnr, 'modifiable', v:false)
        call nvim_buf_set_option(bufnr, 'filetype', 'valtair')
        call nvim_buf_set_option(bufnr, 'bufhidden', 'wipe')
        call nvim_buf_set_var(bufnr, '&scrolloff', 0)
        call nvim_buf_set_var(bufnr, '&sidescrolloff', 0)

        let items = self.impl.items(line_numbers)
        if empty(items)
            return
        endif

        let self.tiles = map(items, { _, item -> valtair#tile#new(self.event_service, item, bufnr) })

        for tile in self.tiles
            call tile.open()
        endfor
        call self.tiles[0].enter()

        call self.event_service.on_buffer_cursor_moved(bufnr)

        let self.current = 0
    endfunction

    function! arranger.enter_next() abort
        if empty(self.tiles)
            return
        endif

        let index = (self.current + 1) % len(self.tiles)
        call self.tiles[index].enter()
        let self.current = index
    endfunction

    function! arranger.enter_prev() abort
        if empty(self.tiles)
            return
        endif

        let index = (self.current - 1) % len(self.tiles)
        call self.tiles[index].enter()
        let self.current = index
    endfunction

    function! arranger.enter_right() abort
        if empty(self.tiles)
            return
        endif

        let row_column = self.impl.row_count * self.impl.column_count
        let index = (self.current + self.impl.row_count) % row_column
        if index >= len(self.tiles)
            let index = index - ((self.impl.column_count - 1) * self.impl.row_count)
        endif
        call self.tiles[index].enter()
        let self.current = index
    endfunction

    function! arranger.enter_left() abort
        if empty(self.tiles)
            return
        endif

        let row_column = self.impl.row_count * self.impl.column_count
        let index = (self.current - self.impl.row_count) % row_column
        if index < 0
            let index = index + self.impl.column_count * self.impl.row_count
        endif
        if index >= len(self.tiles)
            let index = index - self.impl.row_count
        endif
        call self.tiles[index].enter()
        let self.current = index
    endfunction

    function! arranger.close() abort
        for tile in self.tiles
            call tile.close()
        endfor
        let self.tiles = []
        let self.current = 0
    endfunction

    return arranger
endfunction

let s:directory = expand('<sfile>:p:h') . '/arranger'

function! valtair#arranger#get_impl(arranger_options) abort
    let name = a:arranger_options.name
    let path = printf('%s/%s.vim', s:directory, name)
    if !filereadable(path)
        throw printf('arranger not found: %s', name)
    endif

    let func = printf('valtair#arranger#%s#new', name)
    return call(func, [a:arranger_options.options])
endfunction

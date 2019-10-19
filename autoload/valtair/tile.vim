
function! valtair#tile#new(event_service, item, bufnr) abort
    let tile = {
        \ 'bufnr': a:bufnr,
        \ 'window': v:null,
        \ 'event_service': a:event_service,
        \ 'x': a:item.x,
        \ 'y': a:item.y,
        \ 'width': a:item.rect.width,
        \ 'height': a:item.rect.height,
        \ 'line_number': a:item.line_number,
    \ }

    function! tile.open(offset) abort
        let row = self.y - a:offset.y
        let lines = &lines - &cmdheight
        if lines < row + self.height || row < 0
            return v:true
        endif

        let col = self.x - a:offset.x
        if &columns < col + self.width || col < 0
            return v:true
        endif

        if !self.closed()
            return self._set_position(row, col)
        endif

        let self.window = nvim_open_win(self.bufnr, v:false, {
            \ 'relative': 'editor',
            \ 'height': self.height,
            \ 'width': self.width,
            \ 'row': row,
            \ 'col': col,
            \ 'anchor': 'NW',
            \ 'focusable': v:true,
            \ 'external': v:false,
            \ 'style': 'minimal',
        \ })
        call nvim_win_set_option(self.window, 'winhighlight', 'Normal:ValtairTailActive,NormalNC:ValtairTailInactive')
        call nvim_win_set_option(self.window, 'winblend', 15)
        call nvim_win_set_cursor(self.window, [self.line_number, 0])
        call nvim_win_set_var(self.window, '&scrolloff', 999)

        call self.event_service.on_moved_window_cursor(self.window, { id -> nvim_win_set_cursor(self.window, [self.line_number, 0]) }, self.bufnr)
        call self.event_service.on_window_entered(self.window, { id -> self._set_options() }, self.bufnr)
    endfunction

    function! tile.enter() abort
        if self.closed()
            return
        endif
        call nvim_set_current_win(self.window)
    endfunction

    function! tile._set_options() abort
        " FIXME: could not disable CursorLine, CursorColumn highlight
        call nvim_win_set_option(self.window, 'cursorline', v:false)
        call nvim_win_set_option(self.window, 'cursorcolumn', v:false)
    endfunction

    function! tile.close() abort
        if self.closed()
            return
        endif
        call nvim_win_close(self.window, v:false)
    endfunction

    function! tile.closed() abort
        return empty(self.window) || !nvim_win_is_valid(self.window)
    endfunction

    function! tile._set_position(row, col) abort
        call nvim_win_set_config(self.window, {
            \ 'relative': 'editor',
            \ 'row': a:row,
            \ 'col': a:col,
        \ })
    endfunction

    return tile
endfunction

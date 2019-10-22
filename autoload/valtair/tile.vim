
function! valtair#tile#new(event_service, item, bufnr) abort
    let tile = {
        \ 'bufnr': a:bufnr,
        \ 'window': v:null,
        \ 'event_service': a:event_service,
        \ 'target': a:item.target,
        \ '_x': a:item.x,
        \ '_y': a:item.y,
        \ '_width': a:item.rect.width,
        \ '_height': a:item.rect.height,
        \ '_line_number': a:item.target.line_number,
        \ '_index': a:item.index,
    \ }

    function! tile.open(offset) abort
        let row = self._y - a:offset.y
        let lines = &lines - &cmdheight - 1
        if lines < row || row + self._height < 0
            return self.close()
        endif

        let col = self._x - a:offset.x
        let columns = &columns - 1
        if columns < col || col + self._width < 0
            return self.close()
        endif

        let height = self._height
        if row <= lines && row + self._height - 1 > lines
            let height = lines - row + 1
        elseif row < 0
            let height = self._height + row
        endif

        let width = self._width
        if col <= columns && col + self._width - 1 > columns
            let width = columns - col + 1
        elseif col < 0
            let width = self._width + col
        endif

        if !self.closed()
            return self._set_position(row, col, width, height)
        endif

        let self.window = nvim_open_win(self.bufnr, v:false, {
            \ 'relative': 'editor',
            \ 'width': width,
            \ 'height': height,
            \ 'row': row,
            \ 'col': col,
            \ 'anchor': 'NW',
            \ 'focusable': v:true,
            \ 'external': v:false,
            \ 'style': 'minimal',
        \ })
        call nvim_win_set_option(self.window, 'winhighlight', 'Normal:ValtairTailActive,NormalNC:ValtairTailInactive')
        call nvim_win_set_option(self.window, 'winblend', 15)
        call nvim_win_set_cursor(self.window, [self._line_number, 0])
        call nvim_win_set_var(self.window, '&scrolloff', 999)

        call self.event_service.on_moved_window_cursor(self.window, { id -> nvim_win_set_cursor(self.window, [self._line_number, 0]) }, self.bufnr)
        call self.event_service.on_window_entered(self.window, { id -> self._on_enter() }, self.bufnr)
    endfunction

    function! tile.enter() abort
        if self.closed()
            return
        endif
        call nvim_set_current_win(self.window)
    endfunction

    function! tile._on_enter() abort
        call self._set_options()
        call self.event_service.tile_entered(self.bufnr, self._index)
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

    function! tile.displayed_all(offset) abort
        if self.closed()
            return v:false
        endif

        let col = self._x - a:offset.x
        if col < 0 || col + self._width - 1 > &columns - 1
            return v:false
        endif

        let row = self._y - a:offset.y
        if row < 0 || row + self._height - 1 > &lines - &cmdheight - 1
            return v:false
        endif

        return v:true
    endfunction

    function! tile._set_position(row, col, width, height) abort
        call nvim_win_set_config(self.window, {
            \ 'relative': 'editor',
            \ 'row': a:row,
            \ 'col': a:col,
            \ 'width': a:width,
            \ 'height': a:height,
        \ })
    endfunction

    function! tile.offset() abort
        let x = max([self._x + self._width - &columns + 1, 0])
        let y = max([self._y + self._height - (&lines - &cmdheight) + 1, 0])
        return {'x': x, 'y': y}
    endfunction

    return tile
endfunction

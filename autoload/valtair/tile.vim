
function! valtair#tile#new(event_service, item, bufnr) abort
    let tile = {
        \ 'bufnr': a:bufnr,
        \ 'window': v:null,
        \ 'event_service': a:event_service,
        \ 'item': a:item,
    \ }

    function! tile.open() abort
        let self.window = nvim_open_win(self.bufnr, v:false, {
            \ 'relative': 'editor',
            \ 'height': self.item.rect.height,
            \ 'width': self.item.rect.width,
            \ 'row': self.item.y,
            \ 'col': self.item.x,
            \ 'anchor': 'NW',
            \ 'focusable': v:true,
            \ 'external': v:false,
            \ 'style': 'minimal',
        \ })
        call nvim_win_set_option(self.window, 'winhighlight', 'Normal:ValtairTailActive,NormalNC:ValtairTailInactive')
        call nvim_win_set_option(self.window, 'winblend', 15)
        call nvim_win_set_cursor(self.window, [self.item.line_number, 0])
        call nvim_win_set_var(self.window, '&scrolloff', 999)

        call self.event_service.on_moved_window_cursor(self.window, { id -> nvim_win_set_cursor(self.window, [self.item.line_number, 0]) }, self.bufnr)
        call self.event_service.on_window_entered(self.window, { id -> self._set_options() }, self.bufnr)
    endfunction

    function! tile.enter() abort
        if !nvim_win_is_valid(self.window)
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
        if !nvim_win_is_valid(self.window)
            return
        endif
        call nvim_win_close(self.window, v:false)
    endfunction

    return tile
endfunction

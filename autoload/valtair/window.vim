
function! valtair#window#new(event_service, bufnr, line_number) abort
    let window = {
        \ '_event_service': a:event_service,
        \ '_window': v:null,
        \ '_bufnr': a:bufnr,
        \ '_line_number': a:line_number,
    \ }

    function! window.open(row, col, width, height, enter_callback) abort
        if !self.closed()
            return self.set_config(a:row, a:col, a:width, a:height)
        endif

        let self._window = nvim_open_win(self._bufnr, v:false, {
            \ 'relative': 'editor',
            \ 'width': a:width,
            \ 'height': a:height,
            \ 'row': a:row,
            \ 'col': a:col,
            \ 'anchor': 'NW',
            \ 'focusable': v:true,
            \ 'external': v:false,
            \ 'style': 'minimal',
        \ })
        call nvim_win_set_option(self._window, 'winhighlight', 'Normal:ValtairTailActive,NormalNC:ValtairTailInactive')
        call nvim_win_set_option(self._window, 'winblend', 15)
        call nvim_win_set_cursor(self._window, [self._line_number, 0])
        call nvim_win_set_var(self._window, '&scrolloff', 999)

        call self._event_service.on_moved_window_cursor(self._window, { id -> nvim_win_set_cursor(self._window, [self._line_number, 0]) }, self._bufnr)
        call self._event_service.on_window_entered(self._window, a:enter_callback, self._bufnr)
    endfunction

    function! window.enter() abort
        if self.closed()
            return
        endif
        call nvim_set_current_win(self._window)
    endfunction

    function! window.close() abort
        if self.closed()
            return
        endif
        call nvim_win_close(self._window, v:false)
    endfunction

    function! window.closed() abort
        return empty(self._window) || !nvim_win_is_valid(self._window)
    endfunction

    function! window.set_config(row, col, width, height) abort
        call nvim_win_set_config(self._window, {
            \ 'relative': 'editor',
            \ 'row': a:row,
            \ 'col': a:col,
            \ 'width': a:width,
            \ 'height': a:height,
        \ })
    endfunction

    function! window.reset_option() abort
        " FIXME: could not disable CursorLine, CursorColumn highlight
        call nvim_win_set_option(self._window, 'cursorline', v:false)
        call nvim_win_set_option(self._window, 'cursorcolumn', v:false)
    endfunction

    return window
endfunction

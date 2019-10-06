
function! valtair#tile#new(item, bufnr) abort
    let tile = {
        \ 'bufnr': a:bufnr,
        \ 'window': v:null,
        \ 'item': a:item,
    \ }

    function! tile.open() abort
        let self.window = nvim_open_win(self.bufnr, v:false, {
            \ 'relative': 'editor',
            \ 'height': self.item.height,
            \ 'width': self.item.width,
            \ 'row': self.item.row,
            \ 'col': self.item.col,
            \ 'anchor': 'NW',
            \ 'focusable': v:false,
            \ 'external': v:false,
            \ 'style': 'minimal',
        \ })
        call nvim_win_set_option(self.window, 'winhighlight', 'Normal:ValtairTailActive,NormalNC:ValtairTailInactive')
        call nvim_win_set_option(self.window, 'winblend', 15)
        call nvim_win_set_cursor(self.window, [self.item.line_number, 0])
    endfunction

    function! tile.enter() abort
        call nvim_set_current_win(self.window)

        " FIXME: could not disable CursorLine, CursorColumn highlight
        call nvim_win_set_option(self.window, 'cursorline', v:false)
        call nvim_win_set_option(self.window, 'cursorcolumn', v:false)
    endfunction

    return tile
endfunction

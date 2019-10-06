
function! valtair#tile#new(item) abort
    let bufnr = nvim_create_buf(v:false, v:true)
    let space = repeat(' ', (a:item.width - strlen(a:item.text)) / 2)
    let lines = ['', space . a:item.text, '']
    call nvim_buf_set_lines(bufnr, 0, -1, v:true, lines)
    call nvim_buf_set_option(bufnr, 'modifiable', v:false)
    call nvim_buf_set_option(bufnr, 'filetype', 'valtair')
    call nvim_buf_set_var(bufnr, '&scrolloff', 0)
    call nvim_buf_set_var(bufnr, '&sidescrolloff', 0)

    let tile = {
        \ 'bufnr': bufnr,
        \ 'window': v:null,
        \ 'item': a:item,
        \ 'cursor_pos': [float2nr(round(a:item.height / 2.0)), 0],
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
    endfunction

    function! tile.enter() abort
        call nvim_set_current_win(self.window)
        call nvim_win_set_cursor(self.window, self.cursor_pos)

        " FIXME: could not disable CursorLine, CursorColumn highlight
        call nvim_win_set_option(self.window, 'cursorline', v:false)
        call nvim_win_set_option(self.window, 'cursorcolumn', v:false)
    endfunction

    return tile
endfunction

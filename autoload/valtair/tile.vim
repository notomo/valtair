
let s:width = 30
let s:height = 3

function! valtair#tile#new(item) abort
    let bufnr = nvim_create_buf(v:false, v:true)
    let space = repeat(' ', (s:width - strlen(a:item)) / 2)
    let lines = ['', space . a:item, '']
    call nvim_buf_set_lines(bufnr, 0, -1, v:true, lines)
    call nvim_buf_set_option(bufnr, 'modifiable', v:false)
    call nvim_buf_set_option(bufnr, 'filetype', 'valtair')
    call nvim_buf_set_var(bufnr, '&scrolloff', 0)
    call nvim_buf_set_var(bufnr, '&sidescrolloff', 0)

    let tile = {
        \ 'bufnr': bufnr,
        \ 'window': v:null,
    \ }

    function! tile.open(row, col) abort
        let self.window = nvim_open_win(self.bufnr, v:false, {
            \ 'relative': 'editor',
            \ 'height': s:height,
            \ 'width': s:width,
            \ 'row': a:row,
            \ 'col': a:col,
            \ 'anchor': 'NE',
            \ 'focusable': v:false,
            \ 'external': v:false,
            \ 'style': 'minimal',
        \ })
        call nvim_win_set_option(self.window, 'winhighlight', 'Normal:ValtairTailActive,NormalNC:ValtairTailInactive')
    endfunction

    function! tile.enter() abort
        call nvim_set_current_win(self.window)
        call nvim_win_set_cursor(self.window, [2, 0])

        " FIXME: could not disable CursorLine, CursorColumn highlight
        call nvim_win_set_option(self.window, 'cursorline', v:false)
        call nvim_win_set_option(self.window, 'cursorcolumn', v:false)
    endfunction

    return tile
endfunction

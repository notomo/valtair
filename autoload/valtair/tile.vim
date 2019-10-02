
let s:width = 30
let s:height = 3

function! valtair#tile#new(item) abort
    let bufnr = nvim_create_buf(v:false, v:true)
    let space = repeat(' ', (s:width - strlen(a:item)) / 2)
    let lines = ['', space . a:item . space, '']
    call nvim_buf_set_lines(bufnr, 0, -1, v:true, lines)

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
        call nvim_win_set_option(self.window, 'winhighlight', 'Normal:ValtairTail')
    endfunction

    return tile
endfunction

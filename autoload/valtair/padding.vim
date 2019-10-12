
function! valtair#padding#new(top_bottom) abort
    let padding = {
        \ '_left_space': '',
        \ '_width': 0,
        \ 'lines': repeat([''], a:top_bottom),
        \ 'height':  a:top_bottom + 1 + a:top_bottom,
    \ }

    function! padding.add_left(text) abort
        if !empty(self._left_space)
            return self._left_space . a:text
        endif
        let left_space = repeat(' ', (self._width - strlen(a:text)) / 2)
        return left_space . a:text
    endfunction

    function! padding.with_left(left) abort
        let self._left_space = repeat(' ', a:left)
        return self
    endfunction

    function! padding.with_width(width) abort
        let self._width = a:width
        return self
    endfunction

    return padding
endfunction

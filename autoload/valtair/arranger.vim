
let s:arrangers = {}

function! valtair#arranger#new(event_service, impl) abort
    let arranger = valtair#arranger#find()
    if !empty(arranger)
        call arranger.close()
    endif

    let buffer = valtair#buffer#new(a:event_service, a:impl.padding)
    let arranger = {
        \ 'impl': a:impl,
        \ '_tiles': valtair#tiles#new(a:event_service, buffer),
        \ '_buffer': buffer,
        \ 'logger': valtair#logger#new('arranger'),
    \ }

    function! arranger.open_tiles(texts) abort
        let line_numbers = self._buffer.get_line_numbers(a:texts)
        let items = self.impl.items(line_numbers)
        if empty(items)
            return
        endif
        call self._tiles.open(items, self._buffer.bufnr)

        call self._buffer.fix_cursor()

        let s:arrangers[self._buffer.bufnr] = self
        call self._buffer.on_wiped({ bufnr -> remove(s:arrangers, bufnr) })
        call self._buffer.on_tile_entered({ index -> self.impl.enter(index) })

        call self.enter('first')
    endfunction

    function! arranger.enter(name) abort
        if !has_key(self.impl, a:name)
            return valtair#messenger#new().warn('not implemented action: ' . a:name)
        endif

        let index = self.impl[a:name]()
        call self._tiles.enter(index)
    endfunction

    function! arranger.close() abort
        call self._buffer.wipe()
        call self._tiles.clear()
    endfunction

    return arranger
endfunction

function! valtair#arranger#find() abort
    let tab_windows = gettabinfo(tabpagenr())[0]['windows']

    for [bufnr, arranger] in items(s:arrangers)
        let windows = win_findbuf(bufnr)
        if empty(windows)
            continue
        endif

        if index(tab_windows, windows[0]) != -1
            return arranger
        endif
    endfor

    return {}
endfunction

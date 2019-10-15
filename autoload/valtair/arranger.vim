
let s:arrangers = {}

function! valtair#arranger#new(event_service, impl) abort
    let arranger = valtair#arranger#find()
    if !empty(arranger)
        call arranger.close()
    endif

    let arranger = {
        \ 'tiles': [],
        \ 'impl': a:impl,
        \ 'event_service': a:event_service,
        \ '_buffer': valtair#buffer#new(a:event_service, a:impl.padding),
        \ 'logger': valtair#logger#new('arranger'),
    \ }

    function! arranger.open_tiles(texts) abort
        let line_numbers = self._buffer.get_line_numbers(a:texts)
        let items = self.impl.items(line_numbers)
        if empty(items)
            return
        endif

        let self.tiles = map(items, { _, item -> valtair#tile#new(self.event_service, item, self._buffer.bufnr) })
        for tile in self.tiles
            call tile.open()
        endfor

        call self._buffer.fix_cursor()

        let s:arrangers[self._buffer.bufnr] = self
        call self._buffer.on_wiped({ bufnr -> remove(s:arrangers, bufnr) })

        call self.enter('first')
    endfunction

    function! arranger.enter(name) abort
        if !has_key(self.impl, a:name)
            return valtair#messenger#new().warn('not implemented action: ' . a:name)
        endif

        let index = self.impl[a:name]()
        call self.tiles[index].enter()
    endfunction

    function! arranger.close() abort
        call self._buffer.wipe()
        let self.tiles = []
    endfunction

    return arranger
endfunction

function! valtair#arranger#find() abort
    for [bufnr, arranger] in items(s:arrangers)
        let windows = win_findbuf(bufnr)
        if empty(windows)
            continue
        endif

        let tab_windows = gettabinfo(tabpagenr())[0]['windows']
        if index(tab_windows, windows[0]) != -1
            return arranger
        endif
    endfor

    return {}
endfunction

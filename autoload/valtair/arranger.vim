
function! valtair#arranger#new(impl) abort
    let arranger = {
        \ 'tiles': [],
        \ 'impl': a:impl,
        \ 'current': 0,
    \ }

    function! arranger.open_tiles(texts) abort
        let items = self.impl.items(a:texts)
        if empty(items)
            return
        endif

        let self.tiles = map(items, { _, item -> valtair#tile#new(item) })

        for tile in self.tiles
            call tile.open()
        endfor
        call self.tiles[0].enter()

        let self.current = 0
    endfunction

    function! arranger.enter_next() abort
        if empty(self.tiles)
            return
        endif

        if self.current + 1 >= len(self.tiles)
            call self.tiles[0].enter()
            let self.current = 0
            return
        endif

        let index = self.current + 1
        call self.tiles[index].enter()
        let self.current = index
    endfunction

    function! arranger.enter_prev() abort
        if empty(self.tiles)
            return
        endif

        if self.current - 1 < 0
            let index = len(self.tiles) - 1
            call self.tiles[index].enter()
            let self.current = index
            return
        endif

        let index = self.current - 1
        call self.tiles[index].enter()
        let self.current = index
    endfunction

    return arranger
endfunction

let s:directory = expand('<sfile>:p:h') . '/arranger'

function! valtair#arranger#get_impl(arranger_options) abort
    let name = a:arranger_options.name
    let path = printf('%s/%s.vim', s:directory, name)
    if !filereadable(path)
        throw printf('arranger not found: %s', name)
    endif

    let func = printf('valtair#arranger#%s#new', name)
    return call(func, [a:arranger_options.options])
endfunction


let s:actions = {
    \ 'first': { arranger -> arranger.enter('first') },
    \ 'last': { arranger -> arranger.enter('last') },
    \ 'next': { arranger -> arranger.enter('next') },
    \ 'prev': { arranger -> arranger.enter('prev') },
    \ 'up': { arranger -> arranger.enter('up') },
    \ 'down': { arranger -> arranger.enter('down') },
    \ 'left': { arranger -> arranger.enter('left') },
    \ 'right': { arranger -> arranger.enter('right') },
    \ 'quit': { arranger -> arranger.close() },
\ }

function! valtair#commander#new(arranger) abort
    let commander = {
        \ '_arranger': a:arranger,
        \ 'logger': valtair#logger#new('commander'),
    \ }

    function! commander.call(name) abort
        if has_key(s:actions, a:name)
            call self.logger.log('arranger action: ' . a:name)
            call s:actions[a:name](self._arranger)
            return v:null
        endif

        let target = self._arranger.current_target()
        let impl = valtair#loader#new().load('valtair/commander', target.type, [])
        if has_key(impl, a:name)
            call self._arranger.close()

            call self.logger.log('action: ' . a:name)
            call impl[a:name](target)
            return v:null
        endif

        return 'not found action: ' . a:name
    endfunction

    return commander
endfunction

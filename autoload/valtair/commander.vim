
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
            return s:actions[a:name](self._arranger)
        endif

        let [impl, target] = self._load_impl()
        if has_key(impl, a:name)
            call self._arranger.close()

            call self.logger.log('action: ' . a:name)
            return impl[a:name](target)
        endif

        return 'not found action: ' . a:name
    endfunction

    function! commander.action_names() abort
        let action_names = keys(s:actions)

        let [impl, _] = self._load_impl()
        let methods = filter(keys(impl), { _, v -> v !~? '^_' })

        call extend(action_names, methods)
        return action_names
    endfunction

    function! commander._load_impl() abort
        let target = self._arranger.current_target()
        let impl = valtair#loader#new().load('valtair/commander', target.type, [])
        return [impl, target]
    endfunction

    return commander
endfunction

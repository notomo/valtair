
function! valtair#commander#new(type) abort
    let impl = valtair#loader#new().load('valtair/commander', a:type, [])

    let commander = {
        \ '_impl': impl,
    \ }

    function! commander.get(name, value) abort
        if !has_key(self._impl, a:name)
            let err = 'not found action name: ' . a:name
            return [v:null, err]
        endif

        let name = a:name
        let value = a:value
        return [{ -> self._impl[name](value) }, v:null]
    endfunction

    return commander
endfunction

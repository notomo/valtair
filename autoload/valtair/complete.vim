
function! valtair#complete#do(current_arg, line, _cursor_position) abort
    let logger = valtair#logger#new('complete.do')

    let arranger = valtair#arranger#find()
    if empty(arranger)
        return ''
    endif
    let candidates = valtair#commander#new(arranger).action_names()

    call logger.log(candidates)
    return join(candidates, "\n")
endfunction

function! valtair#complete#main(current_arg, line, _cursor_position) abort
    let logger = valtair#logger#new('complete.main')

    let [option_name, _] = valtair#option#parse_one(a:current_arg)
    if !empty(option_name) && (option_name ==# 'arranger' || option_name ==# 'collector')
        let values = valtair#loader#new().names(option_name)
        let candidates = map(values, {_, v -> printf('-%s=%s', option_name, v)})
        call logger.log(candidates)
        return join(candidates, "\n")
    endif

    let [current, err] = valtair#option#parse_flatten(a:line)
    if !empty(err)
        call valtair#messenger#new().error('failed to parse: ' . err)
        return []
    endif
    let names = valtair#option#names()
    let candidates = map(names, { _, name -> printf('-%s=', substitute(name, '_', '-', 'g'))})

    let current_keys = keys(current)
    call map(current_keys, { _, name -> printf('-%s=', substitute(name, '_', '-', 'g'))})

    call filter(candidates, { _, k -> count(current_keys, k) == 0 })

    call logger.log(candidates)
    return join(candidates, "\n")
endfunction

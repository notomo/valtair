
let s:options = {
    \ 'collector': {
        \ 'name': 'cmd',
        \ 'options': {},
    \ }
\ }

function! valtair#option#parse(raw_args) abort
    let options = deepcopy(s:options)
    for arg in split(a:raw_args, '\v(\\\zs\\\s+|[^\\]\zs\s+)')
        let [key, value] = valtair#option#parse_one(arg)
        if empty(key)
            continue
        endif

        let splitted = split(key, '-')
        if len(splitted) >= 2
            let options[splitted[0]]['options'][splitted[1]] = value
        else
            let options[splitted[0]]['name'] = value
        endif
    endfor

    call valtair#logger#new('option').dict_log(options)
    return options
endfunction

function! valtair#option#parse_one(factor) abort
    if a:factor[0] !=# '-' || len(a:factor) <= 1
        return ['', a:factor]
    endif

    let key_value = split(a:factor[1:], '=', v:true)
    if len(key_value) >= 2
        let key = key_value[0]
        let value = join(key_value[1:], '=')
        return [key, value]
    endif

    let [key] = key_value
    return [key, v:true]
endfunction

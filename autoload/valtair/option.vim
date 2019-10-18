
let s:options = {
    \ 'collector': {
        \ 'name': 'cmd',
        \ 'options': {},
    \ },
    \ 'arranger': {
        \ 'name': 'vertical',
        \ 'options': {
            \ 'width': 30,
            \ 'row_padding': 1,
        \ },
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
            let sub_key = join(splitted[1:], '_')
            let options[splitted[0]]['options'][sub_key] = value
        else
            let options[splitted[0]]['name'] = value
        endif
    endfor

    let options.arranger.options.width = str2nr(options.arranger.options.width)
    if options.arranger.options.width <= 0
        let err = 'invalid arranger width: ' . options.arranger.options.width
        return [v:null, err]
    endif

    let options.arranger.options.row_padding = str2nr(options.arranger.options.row_padding)
    if options.arranger.options.row_padding < 0
        let err = 'invalid arranger row_padding: ' . options.arranger.options.row_padding
        return [v:null, err]
    endif

    call valtair#logger#new('option').log(options)

    return [options, v:null]
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

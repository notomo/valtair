
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
            \ 'max_row': v:null,
            \ 'max_column': v:null,
        \ },
    \ }
\ }

let s:empty_options = deepcopy(s:options)
for key in keys(s:options)
    let s:empty_options[key].name = v:null
    for option_name in keys(s:empty_options[key].options)
        let s:empty_options[key]['options'][option_name] = v:null
    endfor
endfor

function! valtair#option#names() abort
    return keys(s:flatten(deepcopy(s:empty_options)))
endfunction

function! valtair#option#parse_flatten(raw_args) abort
    let [options, err] = s:parse(a:raw_args, s:empty_options)
    if !empty(err)
        return [v:null, err]
    endif

    let flatten = s:flatten(options)
    let empty_options = s:flatten(deepcopy(s:empty_options))
    call filter(flatten, { k, v -> !has_key(empty_options, k) || empty_options[k] != v })

    call valtair#logger#new('option').label('flatten').log(flatten)
    return [flatten, v:null]
endfunction

function! valtair#option#parse(raw_args) abort
    let [options, err] = s:parse(a:raw_args, s:options)
    if !empty(err)
        return [v:null, err]
    endif

    let [options.arranger.options.width, err] = s:positive_number(options.arranger.options.width)
    if !empty(err)
        let err = 'invalid arranger width: ' . err
        return [v:null, err]
    endif

    let [options.arranger.options.row_padding, err] = s:not_negative_number(options.arranger.options.row_padding)
    if !empty(err)
        let err = 'invalid arranger row_padding: ' . err
        return [v:null, err]
    endif

    let [options.arranger.options.max_row, err] = s:optional_positive_number(options.arranger.options.max_row)
    if !empty(err)
        let err = 'invalid arranger max_row: ' . err
        return [v:null, err]
    endif

    let [options.arranger.options.max_column, err] = s:optional_positive_number(options.arranger.options.max_column)
    if !empty(err)
        let err = 'invalid arranger max_column: ' . err
        return [v:null, err]
    endif

    call valtair#logger#new('option').log(options)
    return [options, v:null]
endfunction

function! s:parse(raw_args, options) abort
    let options = deepcopy(a:options)
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

function! s:positive_number(value) abort
    let number = str2nr(a:value)
    if number <= 0
        let err = 'should be positive number: ' . number
        return [v:null, err]
    endif
    return [number, v:null]
endfunction

function! s:not_negative_number(value) abort
    let number = str2nr(a:value)
    if number < 0
        let err = 'should not be negative number: ' . number
        return [v:null, err]
    endif
    return [number, v:null]
endfunction

function! s:optional_positive_number(value) abort
    let number = type(a:value) != v:t_string && a:value == v:null ? v:null : str2nr(a:value)
    if type(number) == v:t_number && number <= 0
        let err = 'should be null or positive number: ' . number
        return [v:null, err]
    endif
    return [number, v:null]
endfunction

function! s:flatten(options) abort
    let flatten = {}
    for [key, value] in items(a:options)
        let flatten[key] = value.name
        for [option_key, option_value] in items(value.options)
            let flatten[key . '_' . option_key] = option_value
        endfor
    endfor

    return flatten
endfunction

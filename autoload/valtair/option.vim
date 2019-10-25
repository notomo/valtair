
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

function! valtair#option#all() abort
    let keys = keys(s:options)
    let options_names = map(copy(keys), { _, name -> printf('--%s=', name) })

    for key in keys
        let names = map(keys(s:options[key]['options']), { _, name -> printf('--%s-%s=', key, substitute(name, '_', '-', 'g')) })
        call extend(options_names, names)
    endfor

    return options_names
endfunction

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


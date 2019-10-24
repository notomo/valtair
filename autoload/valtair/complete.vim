
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

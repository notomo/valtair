
let s:arranger = valtair#arranger#new()

function! valtair#main(args) abort
    let event_service = valtair#event#service()

    let collector = valtair#collector#new(event_service)

    let command = valtair#command#new(collector, s:arranger, event_service)
    call command.start()

    return command
endfunction

function! valtair#do(args) abort
    if a:args ==? 'next'
        call s:arranger.enter_next()
    elseif a:args ==? 'prev'
        call s:arranger.enter_prev()
    endif
endfunction

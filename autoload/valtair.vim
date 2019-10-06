
function! valtair#main(args) abort
    let options = valtair#option#parse(a:args)

    let event_service = valtair#event#service()

    let collector_impl = valtair#collector#get_impl(event_service, options.collector)
    let collector = valtair#collector#new(event_service, collector_impl)

    let arranger_impl = valtair#arranger#get_impl(options.arranger)
    let s:arranger = valtair#arranger#new(arranger_impl)

    let command = valtair#command#new(collector, s:arranger, event_service)
    call command.start()

    return command
endfunction

function! valtair#do(args) abort
    if a:args ==? 'next'
        call s:arranger.enter_next()
    elseif a:args ==? 'prev'
        call s:arranger.enter_prev()
    elseif a:args ==? 'quit'
        call s:arranger.close()
    endif
endfunction

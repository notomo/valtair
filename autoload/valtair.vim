
function! valtair#main(args) abort
    let event_service = valtair#event#service()

    let collector = valtair#collector#new(event_service)
    let arranger = valtair#arranger#new()

    let command = valtair#command#new(collector, arranger, event_service)
    call command.start()

    return command
endfunction

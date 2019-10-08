
function! valtair#main(args) abort
    let options = valtair#option#parse(a:args)

    let event_service = valtair#event#service()

    let collector_impl = valtair#collector#get_impl(event_service, options.collector)
    let collector = valtair#collector#new(event_service, collector_impl)

    let arranger_impl = valtair#arranger#get_impl(options.arranger)
    let s:arranger = valtair#arranger#new(event_service, arranger_impl)

    let command = valtair#command#new(collector, s:arranger, event_service)
    call command.start()

    return command
endfunction

let s:actions = {
    \ 'next': { -> s:arranger.enter_next() },
    \ 'prev': { -> s:arranger.enter_prev() },
    \ 'left': { -> s:arranger.enter_left() },
    \ 'right': { -> s:arranger.enter_right() },
    \ 'quit': { -> s:arranger.close() },
\ }

function! valtair#do(args) abort
    call valtair#logger#new('valtair').list_log(a:args)

    if has_key(s:actions, a:args)
        return s:actions[a:args]()
    endif
    throw printf('not found action: %s', a:args)
endfunction


function! valtair#main(args) abort
    let [options, err] = valtair#option#parse(a:args)
    if !empty(err)
        return valtair#messenger#new().error(err)
    endif

    let event_service = valtair#event#service()
    let loader = valtair#loader#new()

    let collector_impl = loader.load('valtair/collector', options.collector.name, [event_service, options.collector.options])
    let collector = valtair#collector#new(event_service, collector_impl)

    let arranger_impl = loader.load('valtair/arranger', options.arranger.name, [options.arranger.options])
    let arranger = valtair#arranger#new(event_service, arranger_impl)

    let command = valtair#command#new(collector, arranger, event_service)
    call command.start()

    return command
endfunction

let s:actions = {
    \ 'first': { arranger -> arranger.enter('first') },
    \ 'last': { arranger -> arranger.enter('last') },
    \ 'next': { arranger -> arranger.enter('next') },
    \ 'prev': { arranger -> arranger.enter('prev') },
    \ 'up': { arranger -> arranger.enter('up') },
    \ 'down': { arranger -> arranger.enter('down') },
    \ 'left': { arranger -> arranger.enter('left') },
    \ 'right': { arranger -> arranger.enter('right') },
    \ 'quit': { arranger -> arranger.close() },
\ }

function! valtair#do(args) abort
    call valtair#logger#new('valtair#do').log(a:args)

    let arranger = valtair#arranger#find()
    if empty(arranger)
        return valtair#messenger#new().warn('not started')
    endif

    if has_key(s:actions, a:args)
        return s:actions[a:args](arranger)
    endif

    return valtair#messenger#new().error('not found action: ' . a:args)
endfunction

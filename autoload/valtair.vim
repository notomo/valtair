
function! valtair#main(args) abort
    let [options, err] = valtair#option#parse(a:args)
    if !empty(err)
        return valtair#messenger#new().error('failed to parse option: ' . err)
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

function! valtair#do(args) abort
    call valtair#logger#new('valtair#do').log(a:args)

    let arranger = valtair#arranger#find()
    if empty(arranger)
        return valtair#messenger#new().warn('not started')
    endif

    let commander = valtair#commander#new(arranger)
    let err = commander.call(a:args)
    if !empty(err)
        return valtair#messenger#new().error('failed to call commander: ' . err)
    endif
endfunction

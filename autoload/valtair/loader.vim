
function! valtair#loader#new() abort
    let loader = {
        \ 'logger': valtair#logger#new('loader'),
    \ }

    function! loader.load(path, name, args) abort
        let autoload_base_path = substitute(a:path, '/', '#', 'g')
        let autoload_path = printf('%s#%s#new', autoload_base_path, a:name)
        call self.logger.log('load: ' . autoload_path)

        return call(autoload_path, a:args)
    endfunction

    function! loader.names(path) abort
        let pattern = printf('autoload/valtair/%s/*.vim', a:path)
        call self.logger.log('load pattern: ' . pattern)

        let paths = globpath(&runtimepath, pattern, v:true, v:true)
        call map(paths, { _, path -> fnamemodify(path, ':t:r')})
        call self.logger.log(paths)
        return paths
    endfunction

    return loader
endfunction

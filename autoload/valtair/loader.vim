
function! valtair#loader#new() abort
    let loader = {
        \ 'logger': valtair#logger#new('loader'),
    \ }

    function! loader.load(path, name, new) abort
        let autoload_base_path = substitute(a:path, '/', '#', 'g')
        let autoload_path = printf('%s#%s#new', autoload_base_path, a:name)
        call self.logger.log('load: ' . autoload_path)

        let F = { -> call(autoload_path, a:000)}
        return a:new(F)
    endfunction

    return loader
endfunction

syntax on
set softtabstop=4
set shiftwidth=4
set tabstop=4
set expandtab
set autoindent
set cindent
filetype indent plugin on
if has("autocmd")

    autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \     exe "normal g`\"" |
    \ endif

    endif


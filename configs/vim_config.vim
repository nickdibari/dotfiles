" Trim trailing whitespace on save
autocmd BufWritePre * :%s/\s\+$//e

" Add command for writing files with `sudo`
command! W :execute ':silent W !sudo tee "%" > /dev/null' | :edit!

" Show line numbers in file
set number

" Open NERDTree plugin if no command line args are specified
autocmd VimEnter * if !argc() | NERDTree | endif

" Open NERDTree explorer on left hand side
let g:NERDTreeWinPos = "left"

" Ignore list of NERDTree nodes
let g:NERDTreeIgnore = ["^bazel-*","^\.git$","\.DS_Store","^\.vagrant"]

" Show hidden files in NERDTree explorer
let g:NERDTreeShowHidden = 1

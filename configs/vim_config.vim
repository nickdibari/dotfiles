" Trim trailing whitespace on save
autocmd BufWritePre * :%s/\s\+$//e

" Add command for writing files with `sudo`
command! W :execute ':silent W !sudo tee "%" > /dev/null' | :edit!

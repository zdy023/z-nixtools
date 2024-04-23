nnoremap cj I//<Esc>
nnoremap cbc I#<Esc>
nnoremap cbt I#<Space><Esc>
" common comments

autocmd FileType c,cpp,go,javascript,java,css,verilog,php nnoremap <buffer> cic I/*<Esc>
autocmd FileType java,php nnoremap <buffer> cij I/**<Esc>
autocmd FileType c,cpp,go,javascript,java,css,verilog,php nnoremap <buffer> cac A*/<Esc>
" C-like comments

autocmd FileType python nnoremap <buffer> cic I"""<Esc>
autocmd FileType python nnoremap <buffer> cac A"""<Esc>
" python comment

autocmd FileType vim nnoremap <buffer> <localleader>ct I"<Space><Esc>
autocmd FileType vim nnoremap <buffer> <localleader>cc I"<Esc>
" vim comment

autocmd FileType tex,matlab,prolog nnoremap <buffer> <localleader>cc I%<Esc>
autocmd FileType tex,matlab,prolog,prompt nnoremap <buffer> <localleader>ct I%<Space><Esc>
autocmd FileType sql,vhdl,haskell nnoremap <buffer> <localleader>cc I--<Space><Esc>
autocmd FileType haskell nnoremap <buffer> cic I{- <esc>
autocmd FileType haskell nnoremap <buffer> cac A -}<esc>
autocmd FileType lhaskell nnoremap <buffer> <localleader>cc 0i> <esc>
autocmd FileType lisp,asm nnoremap <buffer> <localleader>cc I;<Space><Esc>
" other comments

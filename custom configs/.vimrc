set mouse-=a!
set nosi!
set noai!
set showcmd!
set number!
syntax on
set wrap
set backspace=indent,eol,start
set fdm=manual
" basic settings

autocmd BufRead * :loadview
autocmd BufWrite * :mkview!
" automat view management

tnoremap ;; <c-w>:tabn<CR>
tnoremap hh <c-w>:tabN<CR>
" convenient tab switch under terminal mode

nnoremap <c-o> a<CR><Esc>
nnoremap U vU
inoremap jj <Esc>
" basic edit settings

nnoremap cj I//<Esc>
nnoremap cbc I#<Esc>
nnoremap cbt I#<Space><Esc>
" common comments

autocmd FileType c,cpp,go,javascript,java,css,verilog,php nnoremap cic I/*<Esc>
autocmd FileType java,php nnoremap cij I/**<Esc>
autocmd FileType c,cpp,go,javascript,java,css,verilog,php nnoremap cac A*/<Esc>
" C-like comments

autocmd FileType python nnoremap cic I"""<Esc>
autocmd FileType python nnoremap cac A"""<Esc>
" python comment

autocmd FileType vim nnoremap <localleader>ct I"<Space><Esc>
autocmd FileType vim nnoremap <localleader>cc I"<Esc>
" vim comment

autocmd FileType tex,matlab,prolog nnoremap <localleader>cc I%<Esc>
autocmd FileType sql,vhdl nnoremap <localleader>cc I--<Space><Esc>
autocmd FileType lisp,asm nnoremap <localleader>cc I;<Space><Esc>
" other comments

set tabstop=4
set shiftwidth=4
autocmd FileType python,yaml,rust set expandtab
" tab settings

nnoremap ds ^x
nnoremap d2s ^xx
nnoremap d3s ^xxx
nnoremap <localleader>ds ^dw
nnoremap dl $xx
nnoremap d3l $xxx
nnoremap <localleader>dl $bdw
" convenient deletion

inoremap <c-n> <c-x><c-n>
inoremap <c-]> <c-x><c-]>
inoremap <c-f> <c-x><c-f>
inoremap <c-k> <c-x><c-k>
" settings w.r.t. autocompletion

set tags=tags
nnoremap <localleader>ta :AsyncRun<Space>ctags<Space>-R<Space>.<CR>
nnoremap <localleader>tc :!ctags<Space>-R<Space>.<CR>
" for tags (Exuberant Ctags 5.9~svn20110310)

nnoremap <localleader>gt :echo<Space>g:asyncrun_status<CR>
" for plugin asyncrun.vim

function PandocTableMode()
	let g:table_mode_corner='+'
	let g:table_mode_corner_corner='+'
	let g:table_mode_header_fillchar='='
endfunction
function GithubPreferedTableMode()
	let g:table_mode_corner='|'
	let g:table_mode_corner_corner='|'
	let g:table_mode_header_fillchar='-'
endfunction

call GithubPreferedTableMode()
let g:table_mode_delimiter='\t'
" for plugin vim-table-mode

let g:user_emmet_install_global=0
auto Filetype html,markdown EmmetInstall
let g:user_emmet_leader_key='<F8>'
" for emmet

colorscheme torte
hi Normal ctermfg=252 ctermbg=none
" for the theme

set encoding=utf-8
set termencoding=utf-8
set fileencodings=utf-8,gbk,gb2312,gb18030,cp936,utf-16,latin-1
" for encodings

autocmd FileType remind,markdown,tpp set spell
autocmd FileType remind inoremap <c-j> <Space>%_\<CR>
autocmd FileType markdown inoremap <c-j> <br><CR>
" for spell check and quick newline in several formats

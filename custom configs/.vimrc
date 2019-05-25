" my plugin collections:
"
" VundleVim/Vundle.vim
"
" skywind3000/asyncrun.vim
" terryma/vim-expand-region
" vim-scripts/Mark
" tpope/vim-fugitive
"
" dhruvasagar/vim-table-mode
" mattn/emmet-vim
" vim-latex/vim-latex
"
" vim-scripts/fcitx.vim

set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
"Plugin 'tpope/vim-fugitive'
" plugin from http://vim-scripts.org/vim/scripts.html
" Plugin 'L9'
" Git plugin not hosted on GitHub
"Plugin 'git://git.wincent.com/command-t.git'
" git repos on your local machine (i.e. when working on your own plugin)
"Plugin 'file:///home/gmarik/path/to/plugin'
" The sparkup vim script is in a subdirectory of this repo called vim.
" Pass the path to set the runtimepath properly.
"Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
" Install L9 and avoid a Naming conflict if you've already installed a
" different version somewhere else.
" Plugin 'ascenator/L9', {'name': 'newL9'}

Plugin 'skywind3000/asyncrun.vim'
Plugin 'terryma/vim-expand-region'
Plugin 'vim-scripts/Mark'
Plugin 'tpope/vim-fugitive'

Plugin 'dhruvasagar/vim-table-mode'
Plugin 'mattn/emmet-vim'
Plugin 'vim-latex/vim-latex'

Plugin 'vim-scripts/fcitx.vim'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

set mouse-=a!
set backspace=indent,eol,start

set nosi!
set noai!

set showcmd!
set number!
set ruler!

syntax on
set hls
set cursorline

set wrap
set scrolloff=15

set fdm=manual
" basic settings

let g:tex_flavor="latex"

autocmd BufRead,BufNewFile * packadd matchit

autocmd BufRead * :loadview
autocmd BufWrite * :mkview!
" automat view management

tnoremap ;; <c-w>:tabn<CR>
tnoremap ,, <c-w>:tabN<CR>
" convenient tab switch under terminal mode

"nnoremap <c-o> a<CR><Esc>
nnoremap <localleader><space> i <esc>la <esc>h
nnoremap <localleader>x Xlxh
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

autocmd FileType markdown vnoremap <localleader>b s**<c-r>"**<esc>
autocmd FileType markdown vnoremap <localleader>i s*<c-r>"*<esc>

let pattern_cif = '\<if\>:\<else\ if\>:\<else\>'
let pattern_pif = '\<if\>:\<elif\>:\<else\>'
let pattern_shif = '\<if\>:\<else\ if\>\|\<elif\>:\<else\>:\<fi\>'
let pattern_mif = '\<if\>:\<elseif\>:\<else\>:\<end\>'

let pattern_sh = '\<do\>:\<done\>,\<case\>:\<esac\>'
let pattern_matlab = '\(^\s*\)\@<=\(while\|for\|function\)\>:\(^\s*\)\@<=end\>'

let pattern_html = '<\(\w\+\)\(\s\+.*\)*>:</\1>,<!--:-->'
let pattern_tex = '\\begin{\(.\+\)}:\\end{\1},\\left\>:\\right\>'

let pattern_ccmt = '\/\*:\*\/'
let pattern_jcmt = ',\/\*\*:\*\/'

let pattern_hgpp = '<#:>'

let pattern_zh_cn = '（:）,【:】,‘:’,“:”'

autocmd FileType c,cpp let b:match_words=pattern_cif.','.pattern_ccmt
autocmd FileType java let b:match_words=pattern_cif.','.pattern_ccmt.','.pattern_jcmt
autocmd FileType python let b:match_words=pattern_pif
autocmd FileType sh let b:match_words=pattern_sh.','.pattern_shif
autocmd FileType matlab let b:match_words=pattern_mif.','.pattern_matlab

autocmd FileType html let b:match_words=pattern_html.','.pattern_hgpp.','.pattern_zh_cn
autocmd FileType tex let b:match_words=pattern_tex.','.pattern_zh_cn
autocmd FileType markdown let b:match_words=pattern_html.','.pattern_hgpp.','.pattern_tex.','.pattern_zh_cn

set tabstop=4
set shiftwidth=4
autocmd FileType python,yaml,rust set expandtab
" tab settings

nnoremap ds ^x
nnoremap d2s ^xx
nnoremap d3s ^xxx
nnoremap <localleader>ds ^dw
nnoremap dl $x
nnoremap d2l $xx
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
let g:user_emmet_leader_key='<c-g>'
" for emmet

colorscheme torte
hi Normal ctermfg=252 ctermbg=none
" for the theme

set encoding=utf-8
set termencoding=utf-8
set fileencodings=utf-8,gbk,gb2312,gb18030,cp936,utf-16,latin-1
" for encodings

autocmd FileType remind,markdown,tpp set spell
autocmd FileType remind,html inoremap <c-j> <Space>%_\<CR>
autocmd FileType markdown inoremap <c-j> <br><CR>
" for spell check and quick newline in several formats

highlight TempMark  term=bold,reverse cterm=bold ctermfg=red ctermbg=yellow
autocmd BufRead,BufNewFile * match TempMark /\(^\s*\)\@<=\'.\+\'\(\s*$\)\@=/
nnoremap <localleader>hl I'<esc>A'<esc>
nnoremap <localleader>uh :s/\(^\s*\)\@<=\'\\|\'$//g<cr>

highlight TailSpace ctermbg=green
autocmd BufRead,BufNewFile * 2match TailSpace /\s\+$/

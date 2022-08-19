" vimc: novimc:
"
" my plugin collections:
"
" VundleVim/Vundle.vim
"
" skywind3000/asyncrun.vim
" terryma/vim-expand-region
" vim-scripts/Mark
" tpope/vim-fugitive
" SirVer/ultisnips
" zdy023/vim-snippets
"
" dhruvasagar/vim-table-mode
" mattn/emmet-vim
" vim-latex/vim-latex
"
" vim-scripts/fcitx.vim
" rhysd/vim-grammarous

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
Plugin 'Yggdroot/indentLine'
Plugin 'vim-scripts/Mark'
Plugin 'tpope/vim-fugitive'
Plugin 'SirVer/ultisnips'
"Plugin 'honza/vim-snippets'
Plugin 'zdy023/vim-snippets'
Plugin 'majutsushi/tagbar'
Plugin 'tpope/vim-obsession'
Plugin 'maralla/completor.vim'
"Plugin 'Word-Fuzzy-Completion'
Plugin 'voldikss/vim-floaterm'
Plugin 'zdy023/changesPlugin'
Plugin 'mbbill/undotree'
Plugin 'chrisbra/NrrwRgn'
"Plugin 'vim-scripts/AnsiEsc.vim'
Plugin 'chrisbra/Colorizer'

Plugin 'dhruvasagar/vim-table-mode'
Plugin 'mattn/emmet-vim'
Plugin 'vim-latex/vim-latex'
Plugin 'vim-voom/VOoM'
"Plugin 'ycm-core/YouCompleteMe'
"Plugin 'zxqfl/tabnine-vim'
Plugin 'davinche/DrawIt'
Plugin 'wmvanvliet/jupyter-vim'
Plugin 'goerz/jupytext.vim'
"Plugin 'anosillus/vim-ipynb'
"Plugin 'szymonmaszke/vimpyter'
Plugin 'inkarkat/vim-SyntaxRange'

"Plugin 'lilydjwg/fcitx.vim'
Plugin 'rhysd/vim-grammarous'
"Plugin 'vim-scripts/LanguageTool'
Plugin 'mattn/calendar-vim'
"Plugin 'vim-scripts/dokuwiki'
Plugin 'nblock/vim-dokuwiki'
Plugin 'vim-scripts/bnf.vim'
Plugin 'vim-scripts/ebnf.vim'

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
"set cursorline
set nocursorline

set wrap
set scrolloff=7

"set fdm=manual
set fdm=marker
" basic settings

let g:tex_flavor="latex"

autocmd BufRead,BufNewFile * packadd matchit

autocmd BufRead * :loadview
autocmd BufWrite * :mkview!
" automat view management

function Handle_zdy_modeline(zdy_modeline)
	let zdy_mdlpos = matchstrpos(a:zdy_modeline, '\<vimc:\%([^:]\|\\:\)\{-1,}\(\\\)\@<!:')
	if zdy_mdlpos[1]>=0
		if zdy_mdlpos[0] =~ '\<novimc\>'
			return 1
		endif
		let zdy_modeline = strpart(zdy_mdlpos[0], 5, len(zdy_mdlpos[0])-6)
		let zdy_modeline = substitute(zdy_modeline, '\\:', ':', 'g')
		execute(zdy_modeline)
	endif
	return 0
endfunction

function Scan_zdy_modeline()
	let zdy_i = 1
	let zdy_file_len = line('$')
	while(zdy_i<=zdy_file_len)
		if Handle_zdy_modeline(getline(zdy_i))==1
			break
		endif
		let zdy_i = zdy_i+1
	endwhile
endfunction

autocmd BufRead * call Scan_zdy_modeline()

set udf

set ttimeoutlen=100

"tnoremap ;; <c-w>:tabn<CR>
"tnoremap ,, <c-w>:tabN<CR>
" convenient tab switch under terminal mode

let g:floaterm_keymap_new = '<Leader>fc'
let g:floaterm_keymap_prev = '<Leader>fp'
let g:floaterm_keymap_next = '<Leader>fn'
let g:floaterm_keymap_first = '<Leader>f1'
let g:floaterm_keymap_last = '<Leader>f9'
let g:floaterm_keymap_kill = '<Leader>fk'
let g:floaterm_keymap_toggle = '<Leader>ft'
"cnoremap flt<tab> FloatermNew 

cnoremap vsb<tab> vertical sb 
cnoremap vt<tab> vertical terminal 
cnoremap vds<tab> vertical diffsplit 
cnoremap vsts<tab> vertical sts 
cnoremap ho<tab> hid only 
cnoremap nm<tab> norm 
nnoremap <localleader>w :set wrap<cr>
nnoremap <localleader>W :set nowrap<cr>
nnoremap <localleader>cs :set spell<cr>
nnoremap <localleader>cS :set nospell<cr>
nnoremap <localleader>cn :set number<cr>
nnoremap <localleader>cN :set nonumber<cr>

"cnoremap +-<tab> set isk+=- 
"cnoremap --<tab> set isk-=- 
"cnoremap +_<tab> set isk+=_
"cnoremap -_<tab> set isk-=_
cnoremap +<tab> set isk+=
cnoremap -<tab> set isk-=

cnoremap TT<tab> TagbarToggle
autocmd FileType markdown cnoremap <buffer> Vp<tab> Voom pandoc
"autocmd FileType tex cnoremap <buffer> Vlt<tab> Voom latex
autocmd FileType dokuwiki cnoremap <buffer> Vd<tab> Voom dokuwiki

autocmd BufRead,BufNewFile *.bnf set filetype=bnf
autocmd BufRead,BufNewFile *.ebnf set filetype=ebnf

"nnoremap <c-o> a<CR><Esc>
"nnoremap <localleader><space> i <esc>la <esc>h
xnoremap <localleader><space> s <c-r>" <esc>
"nnoremap <localleader>x Xlxh
nnoremap U vU
inoremap <nowait> jj <Esc>
" basic edit settings

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
autocmd FileType sql,vhdl,haskell nnoremap <buffer> <localleader>cc I--<Space><Esc>
autocmd FileType haskell nnoremap <buffer> cic I{- <esc>
autocmd FileType haskell nnoremap <buffer> cac A -}<esc>
autocmd FileType lhaskell nnoremap <buffer> <localleader>cc 0i> <esc>
autocmd FileType lisp,asm nnoremap <buffer> <localleader>cc I;<Space><Esc>
" other comments

nnoremap <localleader>cfa :set formatoptions+=a<cr>
nnoremap <localleader>cfA :set formatoptions-=a<cr>
nnoremap <localleader>cfc :set formatoptions+=mM<cr>
nnoremap <localleader>cfC :set formatoptions-=mM<cr>

xnoremap <localleader>( s(<c-r>")<esc>
xnoremap <localleader>[ s[<c-r>"]<esc>
xnoremap <localleader>< s<<c-r>"><esc>
xnoremap <localleader>{ s{<c-r>"}<esc>
xnoremap <localleader>" s"<c-r>""<esc>
xnoremap <localleader>' s'<c-r>"'<esc>
xnoremap <localleader>` s`<c-r>"`<esc>

autocmd FileType tex xnoremap <buffer> <localleader>` s`<c-r>"'<esc>
autocmd FileType tex xnoremap <buffer> <localleader>! s``<c-r>"''<esc>
autocmd FileType markdown xnoremap <buffer> <localleader>b s**<c-r>"**<esc>
autocmd FileType markdown xnoremap <buffer> <localleader>i s*<c-r>"*<esc>
autocmd FileType markdown xnoremap <buffer> <localleader>e s***<c-r>"***<esc>
autocmd FileType tex xnoremap <buffer> <localleader>b s\textbf{<c-r>"}<esc>
autocmd FileType tex xnoremap <buffer> <localleader>i s\textit{<c-r>"}<esc>
autocmd FileType dokuwiki xnoremap <buffer> <localleader>b s**<c-r>"**<esc>
autocmd FileType dokuwiki xnoremap <buffer> <localleader>i s//<c-r>"//<esc>
autocmd FileType markdown,tex,dokuwiki xnoremap <buffer> <localleader>) s（<c-r>"）<esc>
autocmd FileType markdown,tex,dokuwiki xnoremap <buffer> <localleader>] s〔<c-r>"〕<esc>
autocmd FileType markdown,tex,dokuwiki xnoremap <buffer> <localleader>} s【<c-r>"】<esc>
autocmd FileType markdown,tex,dokuwiki xnoremap <buffer> <localleader>> s《<c-r>"》<esc>
autocmd FileType markdown,tex,dokuwiki xnoremap <buffer> <localleader>@ s“<c-r>"”<esc>
autocmd FileType markdown,tex,dokuwiki xnoremap <buffer> <localleader>~ s‘<c-r>"’<esc>

autocmd FileType markdown,tex,dokuwiki xnoremap <buffer> i) lT（oht）
autocmd FileType markdown,tex,dokuwiki xnoremap <buffer> a) lF（ohf）
autocmd FileType markdown,tex,dokuwiki xnoremap <buffer> i] lT〔oht〕
autocmd FileType markdown,tex,dokuwiki xnoremap <buffer> a] lF〔ohf〕
autocmd FileType markdown,tex,dokuwiki xnoremap <buffer> i} lT【oht】
autocmd FileType markdown,tex,dokuwiki xnoremap <buffer> a} lF【ohf】
autocmd FileType markdown,tex,dokuwiki xnoremap <buffer> i> lT《oht》
autocmd FileType markdown,tex,dokuwiki xnoremap <buffer> a> lF《ohf》
autocmd FileType markdown,tex,dokuwiki xnoremap <buffer> i@ lT“oht”
autocmd FileType markdown,tex,dokuwiki xnoremap <buffer> a@ lF“ohf”
autocmd FileType markdown,tex,dokuwiki xnoremap <buffer> i~ lT‘oht’
autocmd FileType markdown,tex,dokuwiki xnoremap <buffer> a~ lF‘ohf’

autocmd FileType markdown,tex,dokuwiki onoremap <buffer> i) :norm vi)<cr> 
autocmd FileType markdown,tex,dokuwiki onoremap <buffer> a) :norm va)<cr> 
autocmd FileType markdown,tex,dokuwiki onoremap <buffer> i] :norm vi]<cr> 
autocmd FileType markdown,tex,dokuwiki onoremap <buffer> a] :norm va]<cr> 
autocmd FileType markdown,tex,dokuwiki onoremap <buffer> i} :norm vi}<cr> 
autocmd FileType markdown,tex,dokuwiki onoremap <buffer> a} :norm va}<cr> 
autocmd FileType markdown,tex,dokuwiki onoremap <buffer> i> :norm vi><cr> 
autocmd FileType markdown,tex,dokuwiki onoremap <buffer> a> :norm va><cr> 
autocmd FileType markdown,tex,dokuwiki onoremap <buffer> i@ :norm vi@<cr>
autocmd FileType markdown,tex,dokuwiki onoremap <buffer> a@ :norm va@<cr>
autocmd FileType markdown,tex,dokuwiki onoremap <buffer> i~ :norm vi~<cr>
autocmd FileType markdown,tex,dokuwiki onoremap <buffer> a~ :norm va~<cr>

autocmd FileType markdown nnoremap <buffer> <localleader>v :AsyncRun typora %<cr>
autocmd FileType html nnoremap <buffer> <localleader>v :AsyncRun firefox %<cr>
autocmd FileType html,xml cnoremap <buffer> fmt<tab> %s/\(<[^<>]\+>\)\@<=\\|\(>\)\@<!\(<\/[^<>]\+>\)\@=/\r/g

let pattern_cif = '\<if\>:\<else\ if\>:\<else\>'
let pattern_pif = '\<if\>:\<elif\>:\<else\>'
let pattern_shif = '\<if\>:\<else\ if\>\|\<elif\>:\<else\>:\<fi\>'
let pattern_vif = '\<if\>:\<elseif\>:\<else\>:\<endif\>'

let pattern_sh = '\<do\>:\<done\>,\<case\>:\<esac\>'
let pattern_matlab = '\(^\s*\)\@<=\(while\|for\|function\|if\)\>:\(^\s*\)\@<=end\>'
let pattern_vim = '\<\(function\|while\|for\)\>:\<end\1\>'

let pattern_html = '<\(\w\+\)\(\s\+.*\)*>:</\1>,<!--:-->'
let pattern_tex = '\\begin{\(.\+\)}:\\end{\1},\\left\>:\\right\>'

let pattern_ccmt = '\/\*:\*\/'
let pattern_jcmt = '\/\*\*:\*\/'

let pattern_hgpp = '<#:\(\\\)\@<!>'

let pattern_zh_cn = '（:）,【:】,‘:’,“:”,〔:〕,《:》'

autocmd FileType c,cpp let b:match_words=pattern_cif.','.pattern_ccmt
autocmd FileType java let b:match_words=pattern_cif.','.pattern_ccmt.','.pattern_jcmt
autocmd FileType python let b:match_words=pattern_pif
autocmd FileType sh let b:match_words=pattern_sh.','.pattern_shif
autocmd FileType matlab let b:match_words=pattern_matlab
autocmd FileType vim let b:match_words=pattern_vim.','.pattern_vif

autocmd FileType html let b:match_words=pattern_html.','.pattern_hgpp.','.pattern_zh_cn
autocmd FileType tex let b:match_words=pattern_tex.','.pattern_zh_cn
autocmd FileType markdown let b:match_words=pattern_html.','.pattern_hgpp.','.pattern_tex.','.pattern_zh_cn
autocmd FileType remind let b:match_words=pattern_zh_cn

"autocmd FileType tex nnoremap <buffer> \<tab> /<+\(\w\\|\ \)*+><cr>gn

set tabstop=4
set shiftwidth=4
autocmd FileType yaml,haskell,lhaskell set tabstop=2
autocmd FileType yaml,haskell,lhaskell set shiftwidth=2
autocmd FileType python,yaml,rust,haskell,lhaskell set expandtab
" tab settings

nnoremap dt ^x
nnoremap d2t ^xx
nnoremap d3t ^xxx
nnoremap <localleader>dt ^dw
nnoremap dT $x
nnoremap d2T $xx
nnoremap d3T $xxx
nnoremap <localleader>dT $daw
" convenient deletion

"inoremap <c-n> <c-x><c-n>
"inoremap <c-]> <c-x><c-]>
"inoremap <c-f> <c-x><c-f>
"inoremap <c-k> <c-x><c-k>
"inoremap <c-b> <c-r>=getcwd()<cr>
" settings w.r.t. autocompletion

set tags=tags
nnoremap <localleader>ta :AsyncRun<Space>ctags<Space>-R<Space>.<CR>
nnoremap <localleader>tc :!ctags<Space>-R<Space>.<CR>
" for tags (Exuberant Ctags 5.9~svn20110310)
let g:tagbar_sort=0

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
auto FileType html,markdown,xml EmmetInstall
let g:user_emmet_leader_key='<c-g>'
" for emmet

"let g:Tex_CompileRule_dvi = 'xelatex -interaction=nonstopmode $*'
"let g:Tex_CompileRule_dvi = 'latexmk -xelatex -file-line-error -halt-on-error -interaction=nonstopmode $*'
"let g:Tex_CompileRule_dvi = 'latexmk -pdf -file-line-error -halt-on-error -interaction=nonstopmode $*'
let g:Tex_CompileRule_dvi = 'latexmk -pdf -f $*'
"let g:Tex_ViewRule_pdf = 'okular $*'
"let g:Tex_CustomTemplateDirectory = "/home/david/.vim/latex-templates"

colorscheme torte
hi Normal ctermfg=252 ctermbg=none
hi CursorLine term=underline cterm=reverse
" for the theme

set encoding=utf-8
set termencoding=utf-8
set fileencodings=utf-8,gbk,gb2312,gb18030,cp936,big5,utf-16,latin-1
" for encodings

autocmd FileType remind,markdown,tpp set spell
let g:grammarous#languagetool_cmd="languagetool"
let g:grammarous#default_comments_only_filetypes={"*": 1, "help": 0, "markdown": 0, "html": 0}
let g:grammarous#show_first_error=1

autocmd FileType remind inoremap <buffer> <c-j> <Space>%_\<CR>
autocmd FileType markdown,html inoremap <buffer> <c-j> <br><CR>
"autocmd FileType tex inoremap <buffer> <c-j> <space>\\<cr>
" for spell check and quick newline in several formats

nnoremap <localleader>co :ColorToggle<CR>

highlight TempMark  term=bold,reverse cterm=bold ctermfg=red ctermbg=yellow
autocmd BufRead,BufNewFile * syn match TempMark /\(^\s*\)\@<=\'.\+\'\(\s*$\)\@=/
nnoremap <localleader>hl I'<esc>A'<esc>
nnoremap <localleader>uh :s/\(^\s*\)\@<=\'\\|\'$//g<cr>:noh<cr>
nnoremap <localleader>hn /\(^\s*\)\@<=\'.\+\'\(\s*$\)\@=<cr>:noh<cr>
nnoremap <localleader>hN ?\(^\s*\)\@<=\'.\+\'\(\s*$\)\@=<cr>:noh<cr>

highlight TailSpace ctermbg=green
autocmd BufRead,BufNewFile * syn match TailSpace /\s\+$/
nnoremap <localleader>d<space> :s/\s\+$//g<cr>:noh<cr>

highlight GppMacro term=bold cterm=bold ctermfg=green
autocmd BufRead,BufNewFile * syn match GppMacro /<#\w\+\|\(<#\w\+\([^>]\|\\>\)*\)\@<=>/

" highlighting configs for SyntaxRange
"autocmd BufRead,BufNewFile * call SyntaxRange#IncludeEx('start=/\<vimc\=:/ skip=/\\:/ end=/\(\\\)\@<!:/', 'vim')

autocmd FileType markdown call SyntaxRange#Include('```c', '```', 'c', 'NonText')
autocmd FileType markdown call SyntaxRange#Include('```cpp', '```', 'cpp', 'NonText')
autocmd FileType markdown call SyntaxRange#Include('```java', '```', 'java', 'NonText')
autocmd FileType markdown call SyntaxRange#Include('```python', '```', 'python', 'NonText')
autocmd FileType markdown call SyntaxRange#Include('```haskell', '```', 'haskell', 'NonText')

autocmd FileType markdown,dokuwiki call SyntaxRange#Include('\$\$', '\$\$', 'tex')
"autocmd FileType markdown,dokuwiki call SyntaxRange#IncludeEx('start=/\$/ skip=/\\\$/ end=/\(\\\)\@<!\$/', 'tex')

autocmd FileType tex call SyntaxRange#Include('\\begin{lstlisting}\[language=c', '\\end{lstlisting}', 'c', 'NonText')
autocmd FileType tex call SyntaxRange#Include('\\begin{lstlisting}\[language=cpp', '\\end{lstlisting}', 'cpp', 'NonText')
autocmd FileType tex call SyntaxRange#Include('\\begin{lstlisting}\[language=java', '\\end{lstlisting}', 'java', 'NonText')
autocmd FileType tex call SyntaxRange#Include('\\begin{lstlisting}\[language=python', '\\end{lstlisting}', 'python', 'NonText')
autocmd FileType tex call SyntaxRange#Include('\\begin{lstlisting}\[language=haskell', '\\end{lstlisting}', 'haskell', 'NonText')

autocmd FileType dokuwiki call SyntaxRange#Include('<file c', '</file>', 'c', 'NonText')
autocmd FileType dokuwiki call SyntaxRange#Include('<file cpp', '</file>', 'cpp', 'NonText')
autocmd FileType dokuwiki call SyntaxRange#Include('<file java', '</file>', 'java', 'NonText')
autocmd FileType dokuwiki call SyntaxRange#Include('<file python', '</file>', 'python', 'NonText')
autocmd FileType dokuwiki call SyntaxRange#Include('<file haskell', '</file>', 'haskell', 'NonText')
autocmd FileType dokuwiki call SyntaxRange#Include('<file php', '</file>', 'php', 'NonText')
autocmd FileType dokuwiki call SyntaxRange#Include('<file html', '</file>', 'html', 'NonText')
autocmd FileType dokuwiki call SyntaxRange#Include('<code c', '</code>', 'c', 'NonText')
autocmd FileType dokuwiki call SyntaxRange#Include('<code cpp', '</code>', 'cpp', 'NonText')
autocmd FileType dokuwiki call SyntaxRange#Include('<code java', '</code>', 'java', 'NonText')
autocmd FileType dokuwiki call SyntaxRange#Include('<code python', '</code>', 'python', 'NonText')
autocmd FileType dokuwiki call SyntaxRange#Include('<code haskell', '</code>', 'haskell', 'NonText')
autocmd FileType dokuwiki call SyntaxRange#Include('<code php', '</code>', 'php', 'NonText')
autocmd FileType dokuwiki call SyntaxRange#Include('<code html', '</code>', 'html', 'NonText')
autocmd FileType dokuwiki call SyntaxRange#Include('<php>', '</php>', 'php', 'NonText')
autocmd FileType dokuwiki call SyntaxRange#Include('<html>', '</html>', 'html', 'NonText')

"function SafePath(input)
	"return substitute(a:input, "[]()*# $&\\[]", "\\\\\\\\&", "g")
"endfunction
"function GppHTML(output)
	"exec 'set makeprg=gpp\ -H\ -o\ '.SafePath(a:output).'\ '.SafePath(@%)
"endfunction
"function GppTeX(output)
	"exec 'set makeprg=gpp\ -T\ -o\ '.SafePath(a:output).'\ '.SafePath(@%)
"endfunction

set laststatus=2
set statusline=%f\ (%n)%h%w%q%r%m\ %y%=[%{getcwd()}]\ %B@%l/%L\ lines,\ col\ %c,\ %P

"let g:ycm_key_list_select_completion = ['<c-n>']
"let g:ycm_key_list_previous_completion = ['<c-p>']
"let g:ycm_key_invoke_completion = ['<c-k>']
"let g:ycm_key_list_stop_completion = ['<c-b>']

let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-k>"
let g:UltiSnipsJumpBackwardTrigger="<c-l>"

let g:calendar_mark="right"
let g:calendar_monday=0

"set iminsert=2
"set imsearch=-1
"set imcmdline
nnoremap <localleader>ci :let &iminsert=2-&iminsert<cr>:echo &iminsert<cr>
nnoremap <localleader>it :echo &iminsert<cr>

set imactivatefunc=ImActivate
function! ImActivate(active)
  if a:active
	call system('fcitx5-remote -o')
  else
	call system('fcitx5-remote -c')
  endif
endfunction

set imstatusfunc=ImStatus
function! ImStatus()
  return system('fcitx5-remote')[0] is# '2'
endfunction

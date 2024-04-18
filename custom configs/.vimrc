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
Plugin 'easymotion/vim-easymotion'
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
"Plugin 'rhysd/vim-grammarous'
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
set is
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
autocmd BufEnter * set conceallevel=0
nnoremap <localleader>+ :set conceallevel+=1<cr>
nnoremap <localleader>- :set conceallevel-=1<cr>

set ttimeoutlen=100

" <Leader>f{char} to move to {char}
map  <Leader><Leader>f <Plug>(easymotion-bd-f)
nmap <Leader><Leader>f <Plug>(easymotion-overwin-f)

" s{char}{char} to move to {char}{char}
nmap <Leader><Leader>s <Plug>(easymotion-overwin-f2)

" Move to line
map <Leader><Leader>L <Plug>(easymotion-bd-jk)
nmap <Leader><Leader>L <Plug>(easymotion-overwin-line)

" Move to word
map  <Leader><Leader>w <Plug>(easymotion-bd-w)
nmap <Leader><Leader>w <Plug>(easymotion-overwin-w)

" Gif config
map <Leader><Leader>l <Plug>(easymotion-lineforward)
map <Leader><Leader>j <Plug>(easymotion-j)
map <Leader><Leader>k <Plug>(easymotion-k)
map <Leader><Leader>h <Plug>(easymotion-linebackward)

map <space>; <Plug>(easymotion-repeat)
map <Leader><Leader>n <Plug>(easymotion-next)
map <Leader><Leader>N <Plug>(easymotion-prev)

let g:EasyMotion_startofline = 0 " keep cursor column when JK motion

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
cnoremap vsf<tab> vertical sf 
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

"nnoremap <c-o> a<CR><Esc>
"nnoremap <localleader><space> i <esc>la <esc>h
xnoremap <localleader><space> s <c-r>" <esc>
"nnoremap <localleader>x Xlxh
nnoremap U vU
inoremap <nowait> jj <Esc>
" basic edit settings

nnoremap <localleader>cfa :set formatoptions+=a<cr>
nnoremap <localleader>cfA :set formatoptions-=a<cr>
nnoremap <localleader>cfc :set formatoptions+=mM<cr>
nnoremap <localleader>cfC :set formatoptions-=mM<cr>

"autocmd FileType markdown nnoremap <buffer> <localleader>v :AsyncRun typora %<cr>
"autocmd FileType html nnoremap <buffer> <localleader>v :AsyncRun firefox %<cr>
autocmd FileType html,xml cnoremap <buffer> fmt<tab> %s/\(<[^<>]\+>\)\@<=\\|\(>\)\@<!\(<\/[^<>]\+>\)\@=/\r/g

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
nnoremap <localleader>ta :AsyncRun ctags -R --options-maybe=tags-opts .<CR>
nnoremap <localleader>tc :!ctags -R --options-maybe=tags-opts .<CR>
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
auto FileType html,markdown,xml,vue EmmetInstall
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

autocmd FileType remind,markdown,tpp setl spell
let g:grammarous#languagetool_cmd="languagetool"
let g:grammarous#default_comments_only_filetypes={"*": 1, "help": 0, "markdown": 0, "html": 0, "xml": 0}
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

autocmd FileType markdown call SyntaxRange#Include('```sh', '```', 'sh', 'NonText')
autocmd FileType markdown call SyntaxRange#Include('```c', '```', 'c', 'NonText')
autocmd FileType markdown call SyntaxRange#Include('```cpp', '```', 'cpp', 'NonText')
autocmd FileType markdown call SyntaxRange#Include('```java', '```', 'java', 'NonText')
autocmd FileType markdown call SyntaxRange#Include('```python', '```', 'python', 'NonText')
autocmd FileType markdown call SyntaxRange#Include('```haskell', '```', 'haskell', 'NonText')

autocmd FileType markdown,dokuwiki call SyntaxRange#Include('\$\$', '\$\$', 'tex')
"autocmd FileType markdown,dokuwiki call SyntaxRange#IncludeEx('start=/\$/ skip=/\\\$/ end=/\(\\\)\@<!\$/', 'tex')

autocmd FileType tex call SyntaxRange#Include('\\begin{lstlisting}\[language=sh', '\\end{lstlisting}', 'sh', 'NonText')
autocmd FileType tex call SyntaxRange#Include('\\begin{lstlisting}\[language=c', '\\end{lstlisting}', 'c', 'NonText')
autocmd FileType tex call SyntaxRange#Include('\\begin{lstlisting}\[language=cpp', '\\end{lstlisting}', 'cpp', 'NonText')
autocmd FileType tex call SyntaxRange#Include('\\begin{lstlisting}\[language=java', '\\end{lstlisting}', 'java', 'NonText')
autocmd FileType tex call SyntaxRange#Include('\\begin{lstlisting}\[language=python', '\\end{lstlisting}', 'python', 'NonText')
autocmd FileType tex call SyntaxRange#Include('\\begin{lstlisting}\[language=haskell', '\\end{lstlisting}', 'haskell', 'NonText')

autocmd FileType dokuwiki call SyntaxRange#Include('<file sh', '</file>', 'sh', 'NonText')
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

# ztools

Several gadgets for Linux. 

## `base64decode`

Base64 decoder constructed in Python 3.

### Test Environment: 

* Python 3.6.7

### Usage

```sh
base64decode --help
```

```
usage: base64decode [-h] [--decode DECODE] [--file FILE] [--encoding ENCODING]

optional arguments:
  -h, --help            show this help message and exit
  --decode DECODE, -d DECODE
                        Base64 string to be decoded
  --file FILE, -f FILE  Text file where stored Base64 string to be decoded; "-" for stdin; If either
                        this option or "--decode" isn't set, the coded string will be read from stdin
  --encoding ENCODING   Encoding of decoded string; Default to utf-8
```

## wkspace-management

Tools for quickly saving, managing and restoring the workspaces. The workspaces are saved in `~/.wkspace/`. 

### Test Environment:

* GNU bash 4.4.19(1)-release
* wmctrl 1.07
* GNU Awk 4.1.4
* GNOME Terminal 3.30.1 using VTE 0.54.1 +GNUTLS -PCRE2
* GNOME nautilus 3.26.4
* ls 8.28
* cat 8.28
* Vi IMproved 8.0, with patch 1-1766
* rm 8.28

### Usage

* `save-wkspace`/`dump-wkspace` - save current workspace. 
* `ls-wkspace` - list saved workspaces. 
* `chk-wkspace` - check the content of the specific saved workspace. 
* `edit-wkspace` - edit the content of the specific saved workspace. 
* `rm-wkspace` - delete the specific workspace.
* `restore-wkspace`/`load-workspace` - restore the specific workspace.

### Configuration for Autocompletion

In order to configure `bash` to autocomplete the command names, add following statements to `~/.bashrc`. 

```sh
function _ls_wkspace() {
	COMPREPLY=($(compgen -W "$(ls-wkspace)" ${COMP_WORDS[$COMP_CWORD]}))
	COMPREPLY=${COMPREPLY/"("/"\\("}
	COMPREPLY=${COMPREPLY/")"/"\\)"}
	COMPREPLY=${COMPREPLY/"$"/"\\$"}
	return 0
}

complete -F _ls_wkspace restore-wkspace
complete -F _ls_wkspace load-wkspace
complete -F _ls_wkspace rm-wkspace
complete -F _ls_wkspace chk-wkspace
complete -F _ls_wkspace edit-wkspace
# configure about the autocompletion of workspace management commands
```

### About the Saved Workspaces

The workspace is saved as a plain text file named by the date and the current directory. The workspace file looks like: 

```
~/Document/abc
evince ~/Document/demo.pdf
/opt/kingsoft/wps-office/office6/wps ~/Document/foo.docx
```

The first line indicates the current directory opened in the terminal in the current desktop. The following lines record the commands of the visible windows.

## target-pool

Trick for target scheduling.

### Test Environment:

* GNU bash 4.4.19(1)-release
* Python 3.6.7
* Vi IMproved 8.0, with patch 1-1766

### Usage

* `target init` - initiate a target pool (`~/.target_pool`)
* `target edit` - edit the target pool
* `target plan` - edit the every-week plan (`~/.target_update_plan`)
* `target ddl` - edit the one-shot DDL-s (`~/.target_ddl`)
* `target update` - update the weights in the target pool in accordance with `~/.target_update_plan` and `~/.target_ddl`; this command will update the weights subject to a reciprocal function of the difference to the ddl
* `target select` - randomly select a target in accordance with the weights in the target pool
* `target list-ddls` - list the closest DDL-s in `~/.target_update_plan` and `~/.target_ddl` 

### Configuration for Autocompletion

In order to configure `bash` to autocomplete the command names, add following statements to `~/.bashrc`. 

```sh
function _target() {
	COMPREPLY=($(compgen -W "update edit init select plan ddl list-ddls" ${COMP_WORDS[$COMP_CWORD]}))
	return 0
}
complete -F _target target
```

### About the Structure of the Target Pool File

The target pool file is in the following form: 

```
# target	weight
Read papers	3
Lab	4
Literary read	2
```

The lines starting with "#" will be considered as comments. The last field separated by white space characters is considered as the weight while the other fields are considered as the target name integrally. 

### About the Structure of the Every-week Plan File

The plan file is in the following form: 

```
# target	DDL (weekday)
Application for summer practice		4
Prepare for experiment 1
```

The lines starting with "#" will be considered as comments as well. The last field separated by white space characters is considered as the weekday of the periodic deadline of the particular target while the other fields are considered as the target name integrally as well. 

### About the Structure of the One-shot DDL File

The ddl file is in the similar form with the pool file and the plan file: 

```
# target	DDL (yyyy-mm-dd)
Big project of Intelligent Optimisation Algorithms	2019-6-13
Report of oral history requested for Mao Thought	2019-5-31
```

The difference is that the last field indicates the one-shot ddl of the corresponding target but not the weight or the periodic ddl. 

## simple-encryptor

A simple encryption tool using XOR algorithm. 

### Test Environment:

* Python 3.6.7

### Usage

```sh
encrypt --help
```

```
usage: encrypt [-h] [--password [PASSWORD]] [--decode] [--delete]
               [--recursive] [--suffix SUFFIX]
               input [input ...]

positional arguments:
  input

optional arguments:
  -h, --help            show this help message and exit
  --password [PASSWORD], -p [PASSWORD]
  --decode, -d
  --delete
  --recursive, -r
  --suffix SUFFIX, -a SUFFIX
```

## Configuration for `~/.profile` and `~/.bashrc`

### `~/.profile`

```sh
target update
lunar
echo
remind $HOME/.timetable.rem
remind_checker=$(ps -eF |grep 'remind\ -z\ .\+[.]schedule[.]rem')
if [ -z "$remind_checker" ] ; then
	remind -z -k'notify-send -u normal -i terminal Reminder %s' $HOME/.schedule.rem &
fi
```

Environment requirement:

* Lunar Version 2.2-4 (Debian)
* REMIND 03.01.15
* grep (GNU grep) 3.1
* notify-send 0.7.7

### `~/.bashrc`

```sh
shopt -s autocd cdspell
export HISTTIMEFORMAT="%F %T "
# basic bash utilities

PAGER="less -X -M" export LESSOPEN="| /usr/share/source-highlight/src-hilite-lesspipe.sh %s"
export LESS=" -R"
export LESSGLOBALTAGS="global"
# less configuration

alias timetable="vim $HOME/.timetable.rem"
alias schedule="vim $HOME/.schedule.rem"
alias showtodo="remind $HOME/.timetable.rem"
# quick alias of schedule management with help of remind

alias d="dict"
alias ce="trans zh:en"
alias ec="trans en:zh"
# quick alias for dictionaries
```

Environment requirement:

* less 487 (GNU regular expressions)
* GNU Source-highlight 3.1.8 (library: 4|1| 0)
* gtags (GNU GLOBAL) 6.6.2
* REMIND 03.01.15
* dict 1.12.1/rf
* Translate Shell 0.9.6.8

## Configuration for `~/.vimrc`

```vim
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

tnoremap ll <c-w>:tabn<CR>
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
autocmd FileType python,yaml set expandtab
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
```

## Configuration for `~/.tmux.conf`

```
set -g default-terminal "screen-256color"

set -g prefix C-t
unbind C-b
bind C-t send-prefix

bind-key k select-pane -U
bind-key j select-pane -D
bind-key h select-pane -L
bind-key l select-pane -R

setw -g mode-keys vi

# THEME
set -g status-bg black
set -g status-fg white
set -g window-status-current-bg white
set -g window-status-current-fg black
set -g window-status-current-attr bold
set -g status-interval 60
set -g status-left-length 30
set -g status-left '#[fg=green][session:#S] '
set -g status-right '#[fg=yellow]#(cut -d " " -f 1-3 /proc/loadavg)#[default] #[fg=white]%H:%M#[default]'
```

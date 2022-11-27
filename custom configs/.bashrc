shopt -s autocd cdspell
export HISTTIMEFORMAT="%F %T "
# basic bash utilities

#PAGER="less -X -M" export LESSOPEN="| /usr/share/source-highlight/src-hilite-lesspipe.sh %s"
export LESS=" -R"
export LESSGLOBALTAGS="global"
# less configuration

#export EDITOR=vim
#export AUTOSSH_POLL=30
#export PS1='\[\033[01;32m\][\u@\h\[\033[01;33m\] \D{%Y/%m/%d} \@\[\033[01;37m\] \W \[\033[01;31m\]$?\[\033[01;32m\]]\$\[\033[00m\] '
USER_PS='\u@\h'
TIME_PS='\[\033[01;33m\]\D{%Y/%m/%d} \@'
PATH_PS='\[\033[01;37m\]\W'
RSLT_PS='\[\033[0;34m\]$? $(if [[ $? -eq 0 ]]; then echo -n '\''\[\033[0;32m\]'\''\342\234\223; else echo -n '\''\[\033[01;05;31m\]'\''\342\234\227; fi)\[\033[0m\]'
#CONDA_PS='\[\033[01;37m\]$(if [[ -n $CONDA_DEFAULT_ENV ]]; then echo " (`basename $CONDA_DEFAULT_ENV`)"; fi)'
#BRANCH_PS='\[\033[01;34m\]$(if [[ -f branch_flag ]]; then echo -n " <$(<branch_flag)>"; fi)'
#GIT_PS='\[\033[0;32m\]$(if git status &>/dev/null; then echo -n " |$(git branch --show-current)|"; fi)'
export PS1='\[\033[01;32m\]['$USER_PS' '$TIME_PS' '$PATH_PS' '$RSLT_PS'\[\033[01;32m\]]\$\[\033[00m\] '

#alias pale1="dosbox -c \"mount c PAL1\" -c \"c:\" -c \"pal.exe\" -c \"exit\""
#alias qq="/opt/deepinwine/apps/Deepin-TIM/run.sh"
alias ps-exe="ps -eF |grep '\\.exe'"
function kill-ps() {
	ps -eF |awk '/'"$1"'/{if(index($0, "awk")==0) system("kill -n9 "$2); }'
}
#export killps
#alias kill-netease-music="ps -eF |awk '/netease-cloud-music/{if(index(\$0, \"awk\")==0) system(\"kill -n9 \"\$2); }'"
#alias kill-youdao-dict="ps -eF |awk '/youdao-dict/{if(index(\$0, \"awk\")==0) system(\"kill -n9 \"\$2); }'"
#alias kill-netease-music="kill-ps netease-cloud-music"
#alias kill-youdao-dict="kill-ps youdao-dict"
alias gotop="gotop -l .gotop/layout"

alias timetable="vim $HOME/.timetable.rem"
alias schedule="vim $HOME/.schedule.rem"
alias showtodo="remind $HOME/.timetable.rem"
# quick alias of schedule management with help of remind

#alias d="dict"
#alias ce="trans zh:en"
#alias ec="trans en:zh"
# quick alias for dictionaries

function _target() {
	COMPREPLY=($(compgen -W "update edit init select plan ddl list-ddls" ${COMP_WORDS[$COMP_CWORD]}))
	return 0
}
complete -F _target target

function note() {
	mkdir -p ~/.note
	case $1 in
		ls)
			local notes=($(ls ~/.note))
			echo ${notes[@]%.md};;
		edit)
			if [[ ! -e "$HOME/.note/$2.md" ]]; then
				echo "# $2" >"$HOME/.note/$2.md";
			fi
			vim "$HOME/.note/$2.md";;
		rm)
			rm -i "$HOME/.note/$2.md";;
	esac
}
function _complete_note() {
	if [[ $COMP_CWORD -eq 1 || ( ${COMP_WORDS[1]} != edit && ${COMP_WORDS[1]} != ls && ${COMP_WORDS[1]} != rm ) ]]; then
		COMPREPLY=($(compgen -W "ls edit rm" ${COMP_WORDS[$COMP_CWORD]}));
	elif [[ ${COMP_WORDS[1]} == edit || ${COMP_WORDS[1]} == rm ]]; then
		COMPREPLY=($(compgen -W "$(note ls)" ${COMP_WORDS[$COMP_CWORD]}));
	fi
	return 0
}
complete -F _complete_note note

function _complete_version() {
	local subcommands="init list check commit checkout log export"
	if [[ $COMP_CWORD -le 2 ]]; then
		COMPREPLY=($(compgen -W "$subcommands" ${COMP_WORDS[$COMP_CWORD]}))
	fi
}
complete -F _complete_version version

function _complete_backup() {
	if [[ $COMP_CWORD -le 2 ]]; then
		COMPREPLY=($(compgen -W "init backup" ${COMP_WORDS[$COMP_CWORD]}))
	fi
}
complete -F _complete_backup bckp

function _test_ipv4_port() {
	# $1 - protocol, "tcp" or "udp"
	# $2 - port
	local protocol_option code
	if [[ $1 == tcp ]]; then
		protocol_option=t
	elif [[ $1 == udp ]]; then
		protocol_option=u
	fi

	code=$(netstat -a${protocol_option}n |awk 'BEGIN{bound = 0;} $1=="'$1'" && $4~/[[:digit:]]+(\.[[:digit:]]+){3}:'$2'/{bound = 1;} END{print bound;}')
	echo $code
}
function get-random-port() {
	# $1 - protocol, "tcp" or "udp"
	local random_port
	while [[ true ]]; do
		random_port=$(shuf -i 30000-65535 -n1)
		if [[ $(_test_ipv4_port $1 $random_port)==0 ]]; then
			break
		fi
	done
	echo $random_port
}
export -f get-random-port _test_ipv4_port

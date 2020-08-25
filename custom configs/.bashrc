shopt -s autocd cdspell
export HISTTIMEFORMAT="%F %T "
# basic bash utilities

#PAGER="less -X -M" export LESSOPEN="| /usr/share/source-highlight/src-hilite-lesspipe.sh %s"
export LESS=" -R"
export LESSGLOBALTAGS="global"
# less configuration

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
			notes=($(ls ~/.note))
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

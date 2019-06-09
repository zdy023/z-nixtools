shopt -s autocd cdspell
export HISTTIMEFORMAT="%F %T "
# basic bash utilities

#PAGER="less -X -M" export LESSOPEN="| /usr/share/source-highlight/src-hilite-lesspipe.sh %s"
export LESS=" -R"
export LESSGLOBALTAGS="global"
# less configuration

alias pale1="dosbox -c \"mount c PAL1\" -c \"c:\" -c \"pal.exe\" -c \"exit\""
#alias kill-netease-music="ps -eF |awk '/netease-cloud-music/{if(index(\$0, \"awk\")==0) system(\"kill -n9 \"\$2); }'"

alias timetable="vim $HOME/.timetable.rem"
alias schedule="vim $HOME/.schedule.rem"
alias showtodo="remind $HOME/.timetable.rem"
# quick alias of schedule management with help of remind

alias d="dict"
alias ce="trans zh:en"
alias ec="trans en:zh"
# quick alias for dictionaries

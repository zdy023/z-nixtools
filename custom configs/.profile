export XIM_PROGRAM=fcitx
export XIM=fcitx
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS="@im=fcitx"

target update
#lunar
ccal -u
echo
remind $HOME/.timetable.rem
remind_checker=$(ps -eF |grep 'remind\ -z\ .\+')
if [[ -z "$remind_checker" ]] ; then
	remind -z -k'notify-send -u normal -i terminal Reminder %s' $HOME/.schedule.rem &
fi
target list-ddls

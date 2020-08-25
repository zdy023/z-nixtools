export XIM_PROGRAM=fcitx5
export XIM=fcitx5
export GTK_IM_MODULE=fcitx5
export QT_IM_MODULE=fcitx5
export XMODIFIERS="@im=fcitx5"
export INPUT_METHOD=fcitx5

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

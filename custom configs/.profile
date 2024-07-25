export XIM_PROGRAM=fcitx5
export XIM=fcitx5
export GTK_IM_MODULE=fcitx5
export QT_IM_MODULE=fcitx5
export XMODIFIERS="@im=fcitx5"
export INPUT_METHOD=fcitx5

target update
#lunar
#ccal -u
current_activity=$(qdbus org.kde.ActivityManager /ActivityManager/Activities CurrentActivity)
current_activity_name=$(qdbus org.kde.ActivityManager /ActivityManager/Activities ActivityName $current_activity)
if [[ $current_activity_name != 开会 ]]; then
	echo
	remind $HOME/.timetable.rem
	target list-ddls
fi

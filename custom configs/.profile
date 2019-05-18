target update
#lunar
ccal -u
echo
remind $HOME/.timetable.rem
remind_checker=$(ps -eF |grep 'remind\ -z\ .\+')
if [ -z "$remind_checker" ] ; then
	remind -z -k'notify-send -u normal -i terminal Reminder %s' $HOME/.schedule.rem &
fi
target list-ddls

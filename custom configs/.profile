target update
lunar
echo
remind $HOME/.timetable.rem
remind_checker=$(ps -eF |grep 'remind\ -z\ .\+[.]schedule[.]rem')
if [ -z "$remind_checker" ] ; then
	remind -z -k'notify-send -u normal -i terminal Reminder %s' $HOME/.schedule.rem &
fi

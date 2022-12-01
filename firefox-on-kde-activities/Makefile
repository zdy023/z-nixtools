.PHONY: local
local:
	mkdir -p ~/.mozilla/native-messaging-hosts
	install -D test_activity.json ~/.mozilla/native-messaging-hosts
	sed -i -e "s#<home>#$$HOME#g" ~/.mozilla/native-messaging-hosts/test_activity.json
	install --mode 700 -D test_firefox_in_activities.py ~/.local/bin

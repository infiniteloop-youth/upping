#!/bin/sh

# upping - Simple ping based watchdog

TARGET_IP='192.168.1.1'
TARGET_NAME='Router'
CHANNEL='#watchdog'
COUNT='5'
WEBHOOK='https://hooks.slack.com/services/'
PING='/bin/ping'

make_message () {
cat << EOT
{
	"channel": "${CHANNEL}",
	"username": "upping bot",
	"icon_emoji": ":jenkins:",
	"attachments": [
		{
			"color": "$1",
			"author_name": "upping",
			"author_link": "https://github.com/",
			"author_icon": "https://i.pinimg.com/originals/30/7f/a4/307fa4f7f37831684fe3e3ee33ab97d3.png",
			"title": "upping status report",
			"text": "$2",
			"fields": [
				{
					"title": "$3",
					"value": "$4",
					"short": false
				}
			],
			"footer": "Slack API",
			"footer_icon": "https://platform.slack-edge.com/img/default_application_icon.png",
			"ts": "`date +%s`"
		}
	]
}
EOT
}

statistics=`$PING -c $COUNT $TARGET_IP 2>&1`
cmdstatus=$?

if [ $cmdstatus = 0 ]; then
	curl -X POST \
		-H 'Content-type: application/json' \
		--data "$(make_message "good" "$TARGET_NAME is online!" "`echo -n "$statistics"|awk '/PING/{print $2 $3}'`" "packet loss: `echo -n "$statistics"|awk '/packet/{print $6}'`\navg: `echo -n "$statistics"|awk -F "/" '/rtt/{print $5}'` ms")" \
		$WEBHOOK
elif [ $cmdstatus = 1 ]; then
	curl -X POST \
		-H 'Content-type: application/json' \
		--data "$(make_message "danger" "$TARGET_NAME is offline!" "$TARGET_IP" "Network or Destination Host is unreachable")" \
		$WEBHOOK
else
	curl -X POST \
		-H 'Content-type: application/json' \
		--data "$(make_message "warning" "Some error happened!" "$TARGET_IP" "$statistics")" \
		$WEBHOOK
fi

#!/usr/bin/env bash
echo > ./nohup.out
killall natapp
nohup ./natapp -authtoken=b354634ce034314d -loglevel=INFO -log=stdout &

sleep 2 && grep -o 'Tunnel established at tcp://[^ ]*' nohup.out | while read line; do
  json='{
    "body": "'"$line"'",
    "title": "NATAPP",
    "badge": 1,
    "category": "myNotificationCategory",
    "sound": "minuet.caf",
    "icon": "https://day.app/assets/images/avatar.jpg",
    "group": "test",
    "url": ""
  }'

  json_modified=$(echo "$json" | LINE="$line" jq '.body = env.LINE')

  curl -X POST "https://api.day.app/BARD_KEY" \
     -H 'Content-Type: application/json; charset=utf-8' \
     -d "$json_modified"

done

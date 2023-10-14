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

  # 使用jq命令来修改JSON字符串，将读取到的行写入"body"字段
  json_modified=$(echo "$json" | LINE="$line" jq '.body = env.LINE')

  # 使用curl发送JSON数据到API
  curl -X POST "https://api.day.app/BARD_KEY" \
     -H 'Content-Type: application/json; charset=utf-8' \
     -d "$json_modified"

done

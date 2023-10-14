#!/usr/bin/env bash
echo > /home/dinry/opensource/nat/nohup.out
echo > /home/dinry/opensource/nat/nat.log
killall natapp
nohup /home/dinry/opensource/nat/natapp -authtoken=b354634ce034314d -loglevel=INFO -log=stdout  > /home/dinry/opensource/nat/nat.log  &

sleep 2

grep -o 'Tunnel established at tcp://[^ ]*' /home/dinry/opensource/nat/nat.log | while read line; do
  json='{
    "body": "'"$line"'",
    "title": "Test Title",
    "badge": 1,
    "category": "myNotificationCategory",
    "sound": "minuet.caf",
    "icon": "https://day.app/assets/images/avatar.jpg",
    "group": "test",
    "url": "https://mritd.com"
  }'

  # 使用jq命令来修改JSON字符串，将读取到的行写入"body"字段
  json_modified=$(echo "$json" | LINE="$line" jq '.body = env.LINE')

  # 使用curl发送JSON数据到API
  curl -X POST "https://api.day.app/BARK_KEY" \
     -H 'Content-Type: application/json; charset=utf-8' \
     -d "$json_modified"

done

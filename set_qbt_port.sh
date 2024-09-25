#!/bin/bash

# The forwarded port is passed as the first argument to the script
port="$1"

echo "$(date): Setting qBittorrent listen port to $port..."

# Very basic retry logic so we don't fail if qBittorrent isn't running yet
 while ! curl --silent --retry 10 --retry-delay 15 --max-time 10 \
  --data-urlencode "username=${QBT_USER}" \
  --data-urlencode "password=${QBT_PASS}" \
  --output /dev/null \
  --cookie-jar /tmp/qb-cookies.txt \
  http://localhost:${QBT_PORT}/api/v2/auth/login
  do
    sleep 10
  done

curl --silent --retry 10 --retry-delay 15 --max-time 10 \
  --data 'json={"listen_port": "'"$port"'"}' \
  --output /dev/null \
  --cookie /tmp/qb-cookies.txt \
  http://localhost:${QBT_PORT}/api/v2/app/setPreferences

# Check that the port was successfully updated
if [[ $(curl --silent --retry 10 --retry-delay 15 --max-time 10 --cookie /tmp/qb-cookies.txt \
  http://localhost:${QBT_PORT}/api/v2/app/preferences | jq '.listen_port') = $port ]]; then
  echo "$(date): qBittorrent listen port successfully set to $port"
else
  echo "$(date): Error: qBittorrent port was not set"
fi
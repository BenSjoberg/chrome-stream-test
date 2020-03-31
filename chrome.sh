#!/bin/bash

export DISPLAY=:44

URL=${1:-https://time.is}

rm -rf $HOME/.config/google-chrome

exec google-chrome \
  --autoplay-policy=no-user-gesture-required \
  --window-size=1920,1080 \
  --window-position=0,0 \
  --start-fullscreen \
  --no-default-browser-check \
  --no-sandbox \
  --no-first-run \
  --disable-setuid-sandbox \
  --disable-dev-shm-usage \
  --kiosk \
  $URL

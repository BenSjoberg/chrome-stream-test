#!/bin/bash

export DISPLAY=:44

URL='https://www.youtube.com/watch?v=oHg5SJYRHA0'

rm -rf $HOME/.config/google-chrome

exec google-chrome \
  --autoplay-policy=no-user-gesture-required \
  --window-size=1920,1080 \
  --window-position=0,0 \
  --start-fullscreen \
  --no-default-browser-check \
  --no-first-run \
  --kiosk \
  $URL

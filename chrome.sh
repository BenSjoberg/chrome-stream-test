#!/bin/bash

export DISPLAY=:44

exec google-chrome \
  --autoplay-policy=no-user-gesture-required \
  --window-size=1920,1080 \
  --window-position=0,0 \
  --start-fullscreen \
  --no-default-browser-check \
  --kiosk \
  'https://bbb.g2planet.com/bigbluebutton/api/join?fullName=Broadcaster&meetingID=cool_meeting_3&password=afsdfsfsf&checksum=020ee247a20c1a7878af4fe455b0baffbe69d70a'

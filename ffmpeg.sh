#!/bin/bash
cd "$(dirname "$0")" || exit $?

mkdir -p media
rm -f media/test.mkv

exec ffmpeg \
  -r 24 \
  -f x11grab \
  -video_size 1920x1080 \
  -probesize 50M \
  -i :44+0,48 \
  media/test.mkv
  # -f flv "rtmp://34.204.112.179:1935/LiveStreaming-livestream/primary"

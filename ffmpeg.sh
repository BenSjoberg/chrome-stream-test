#!/bin/bash
cd "$(dirname "$0")" || exit $?

exec ffmpeg \
  -r 24 \
  -f x11grab \
  -video_size 1920x1080 \
  -draw_mouse 0 \
  -i :44+0,48 \
  -f alsa \
  -i pulse \
  -pix_fmt yuv420p \
  -preset veryfast \
  -g 48 \
  -c:v libx264 \
  -c:a aac \
  -hls_start_number_source datetime \
  -hls_list_size 20 \
  -f hls -method PUT http://host.docker.internal:8087/test2/index.m3u8
  # -f flv "rtmp://host.docker.internal:1935/live/test"
  # media/test.mkv

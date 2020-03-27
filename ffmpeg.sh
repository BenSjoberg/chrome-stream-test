#!/bin/bash

exec ffmpeg \
  -f x11grab \
  -video_size 1920x1080 \
  -probesize 50M \
  -i :44 \
  -f pulse \
  -i default \
  -crf 18 \
  -pix_fmt yuv420p \
  ~/out.mkv

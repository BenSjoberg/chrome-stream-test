#!/usr/bin/env bash
set -e
cd "$(dirname "$0")"

docker build -t chromestream .
docker run --name chromestream --rm -it -v $PWD:/scripts -w /scripts chromestream

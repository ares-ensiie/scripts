#!/bin/bash

set -e
if [ $# -ne 1 ]; then
  echo "Usage : $0 [CONTAINER NAME]" >&2
  exit 1
fi

cd /home/ares/ares

set -x

docker-compose build --no-cache $1
docker-compose stop $1
docker-compose rm $1
docker-compose up -d $1

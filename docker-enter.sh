#!/bin/bash

set -e
if [ $# -ne 1 ]; then
  echo "Usage : $0 [CONTAINER NAME]" >&2
  exit 1
fi

docker exec -it ares_$1_1 /bin/bash

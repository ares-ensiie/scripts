#!/bin/bash

docker stats $(docker ps | tail -n +2 | tr -s ' ' | rev | cut -d' ' -f 1 | rev)

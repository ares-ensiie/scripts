#!/bin/bash
cd /home/ares/ares/
docker-compose stop
docker-compose rm
sudo service docker stop
sudo /home/ares/scripts/iptables-reset.sh
sudo service docker start
docker-compose up -d


#!/bin/bash

containers=$(docker ps | tail -n +2 | tr -s ' ' | rev | cut -d' ' -f1 | rev)

for container in $containers; do
ip=$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' $container)
echo $container "=> "$ip

done

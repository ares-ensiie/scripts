#!/bin/bash
list=$(docker ps -a --filter="status=exited" | tail -n +2 | awk '{print $NF}')
echo "This will delete the folowing containers :"
echo $list

read -r -p "Are you sure? [y/N] " response
case $response in
  [yY][eE][sS]|[yY]) 
    docker rm $list
  ;;
  *)
  ;;
esac


#!/usr/bin/env bash

container_name="CONT_NAME"
tag="benjilev08/IMAGE_NAME:latest"
dir="PROJECT_DIR"

while getopts c:t:d: option
do
  case "${option}"
    in
    c) container_name=${OPTARG};;
    t) tag=${OPTARG};;
    d) dir=${OPTARG};;
  esac
done

if [[ ! -a $dir ]]
then
  echo "dir does not exist"
  exit 1
fi

if [[ ! -d $dir ]]
then
  echo "dir is not a directory."
  exit 1
fi


if [[ -n $(docker ps -f 'name='${container_name} -q) ]]
then
  docker stop $container_name
  docker rm $container_name
elif [[ -n $(docker ps -a -f 'name='${container_name} -q) ]]
then
  docker rm $container_name
fi

docker build -t $tag $dir

docker run -d \
  --name $container_name \
  -p 80:80 \
  -p 9191:9191 \
  --network testnet \
  $tag

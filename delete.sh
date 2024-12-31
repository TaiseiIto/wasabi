#!/bin/bash

image=$1
container=$2

# Stop the docker container.
if [ -n "$(docker ps --format {{.Names}} | grep -x $container)" ]; then
	docker stop $container
fi

# Delete the docker conatiner.
if [ -n "$(docker ps -a --format {{.Names}} | grep -x $container)" ]; then
	docker rm $container
fi

# Delete the docker image.
if [ -n "$(docker images --format {{.Repository}} | grep -x $image)" ]; then
	docker rmi $image
fi


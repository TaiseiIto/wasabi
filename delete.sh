#!/bin/bash

image=$1
container=$2

# Stop the docker container.
if [ -n "$(docker ps --format {{.Names}} --filter name=^$container\$)" ]; then
	docker stop $container
fi

# Delete the docker conatiner.
if [ -n "$(docker ps -a --format {{.Names}} --filter name=^$container\$)" ]; then
	docker rm $container
fi

# Delete the docker image.
if [ -n "$(docker images --format {{.Repository}} $image)" ]; then
	docker rmi $image
fi


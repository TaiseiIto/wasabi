#!/bin/bash

image=$1
container=$2
vnc_port=$3

# Build a docker image.
if [ -z "$(docker images --format {{.Repository}} | grep -x $image)" ]; then
	docker build --build-arg vnc_port=$vnc_port -t $image .
fi

# Create a docker container.
if [ -z "$(docker ps -a --format {{.Names}} | grep -x $container)" ]; then
	docker create -i -t -p $vnc_port:$vnc_port --privileged --name $container $image /bin/bash
fi

# Start the docker container.
if [ -z "$(docker ps --format {{.Names}} | grep -x $container)" ]; then
	docker start $container
	docker exec --workdir /root/saba $container ./build_saba.sh
	docker exec --workdir /root/wasabi $container ./build_wasabi.sh
	docker stop $container
fi

# Extract WasabiOS
if [ ! -e wasabi.zip ]; then
	docker cp $container:/root/wasabi/wasabi.zip wasabi.zip
fi
if [ ! -d mnt ]; then
	docker cp $container:/root/wasabi/mnt mnt
fi


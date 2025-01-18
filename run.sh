#!/bin/bash

container=$1

docker stop $container
docker start $container
docker exec --workdir /root/wasabi $container ./run_on_container.sh


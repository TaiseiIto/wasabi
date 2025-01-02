#!/bin/bash

container=$1

docker start $container
docker exec $container /bin/bash -c "cd /root/wasabi && ./run_on_container.sh"
docker stop $container


#!/bin/bash

set -e

if [ -z "$1" ]; then
      echo "CLUSTER_ID parameter required"
      exit 255
fi

if [ -z "$2" ]; then
      echo "NODE_ID parameter required"
      exit 255
fi

CLUSTER_ID=$1
NODE_ID=$2

NODE1_IP=`host cropdroid-c1-n1 | cut -d ' ' -f 4`
NODE2_IP=`host cropdroid-c1-n2 | cut -d ' ' -f 4`
NODE3_IP=`host cropdroid-c1-n3 | cut -d ' ' -f 4`

DOCKER_SUBNET=172.20.0.0/16
DOCKER_BASEIP=172.20.0.1
DOCKER_NODE1=172.20.0.11
DOCKER_NODE2=172.20.0.12
DOCKER_NODE3=172.20.0.13
#LISTEN_ADDRESS=`hostname -I | cut -d ' ' -f1`

docker rm cropdroid-c$CLUSTER_ID-n$NODE_ID || true
docker rm roach$NODE_ID || true

docker network create --subnet "${DOCKER_SUBNET}" cropnet || true

docker run -d \
        --name "roach${NODE_ID}" \
        --hostname="roach${NODE_ID}" \
        --net=cropnet \
        -p 26257:26257 -p 8080:8080  \
        -v "${PWD}/cockroach-data:/cockroach/cockroach-data"  \
        jeremyhahn/builder-cockroach-ubuntu cockroach start \
        --insecure \
        --join=roach1,roach2,roach3

read -p "Press any key to proceed once cockroach is started to initialize the database... " -n 1 -r

if [ "${NODE_ID}" == "1" ]; then
  echo "Initializing database..."
  docker exec -it roach1 cockroach init --insecure
  sleep 3
fi

docker run -d \
        --name "cropdroid-c${CLUSTER_ID}-n${NODE_ID}" \
        --hostname="cropdroid-c${CLUSTER_ID}-n${NODE_ID}" \
        --net=cropnet \
        --ip $DOCKER_NODE1 \
        -p 80:80 -p 60020:60020 \
        -v "${PWD}/cropdroid-data:/cropdroid/db" \
        jeremyhahn/cropdroid-builder-cluster-ubuntu /cropdroid/cropdroid cluster \
        --debug \
        --ssl=false \
        --datastore cockroach \
        --datastore-host roach1 \
        --enable-registrations \
        --listen $DOCKER_NODE1 \
        --raft "${NODE1_IP}:60020,${NODE3_IP}:60020,${NODE3_IP}:60020"

if [ "${NODE_ID}" == "1" ]; then
  echo "Initializing cropdroid database..."
  docker exec -it cropdroid-c$CLUSTER_ID-n$NODE_ID /cropdroid/cropdroid config --init --datastore cockroach --datastore-host roach1
fi

docker logs -f cropdroid-c${CLUSTER_ID}-n${NODE_ID}

#docker exec -it cropdroid-c1-n3 /cropdroid/cropdroid config --init --datastore cockroach

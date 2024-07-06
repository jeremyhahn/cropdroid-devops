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

docker stop "roach${NODE_ID}"
docker rm "roach${NODE_ID}"

docker stop "cropdroid-c${CLUSTER_ID}-n${NODE_ID}"
docker rm "cropdroid-c${CLUSTER_ID}-n${NODE_ID}"

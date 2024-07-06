#!/bin/bash

set -e

CROPDROID=./cropdroid
FILES="/var/log/cropdroid/cluster/node-1.log /var/log/cropdroid/cluster/node-2.log /var/log/cropdroid/cluster/node-3.log"
sudo mkdir -p /var/log/cropdroid/cluster
sudo touch $FILES
sudo chown $USER $FILES

$CROPDROID cluster --debug \
    --data-dir ./db/cluster \
    --log-dir /var/log/cropdroid/cluster \
    --log-file /var/log/cropdroid/cluster/node-1.log \
    --keys keys \
    --ssl=false \
    --port 8091 \
    --datastore cockroach \
    --enable-registrations \
    --listen 192.168.1.20 \
    --raft "192.168.1.20:60020,192.168.1.20:60021,192.168.1.20:60022"

$CROPDROID cluster --debug \
    --data-dir ./db/cluster \
    --log-dir /var/log/cropdroid/cluster \
    --log-file /var/log/cropdroid/cluster/node-2.log \
    --keys keys \
    --ssl=false \
    --port 8092 \
    --datastore cockroach \
    --enable-registrations \
    --listen 192.168.1.20 \
    --gossip-peers 192.168.1.20:60010 \
    --gossip-port 60011 \
    --raft "192.168.1.20:60020,192.168.1.20:60021,192.168.1.20:60022" \
    --raft-port 60021

$CROPDROID cluster --debug \
    --data-dir ./db/cluster \
    --log-dir /var/log/cropdroid/cluster \
    --log-file /var/log/cropdroid/cluster/node-3.log \
    --keys keys \
    --ssl=false \
    --port 8093 \
    --datastore cockroach \
    --enable-registrations \
    --listen 192.168.1.20 \
    --gossip-peers "192.168.1.20:60010,192.168.1.20:60011" \
    --gossip-port 60012 \
    --raft "192.168.1.20:60020,192.168.1.20:60021,192.168.1.20:60022" \
    --raft-port 60022

#!/bin/bash

./cropdroid-x64 cluster --debug \
    --data-dir ./db/cluster \
    --log-dir /var/log/cropdroid/cluster \
    --keys keys \
    --ssl=false \
    --port 8094 \
    --join true \
    --datastore cockroach \
    --enable-registrations \
    --listen 192.168.0.71 \
    --gossip-peers "192.168.0.71:60010,192.168.0.71:60011,192.168.0.71:60012" \
    --gossip-port 60013 \
    --raft-port 60023


./cropdroid-x64 cluster --debug \
    --data-dir ./db/cluster \
    --log-dir /var/log/cropdroid/cluster \
    --keys keys \
    --ssl=false \
    --port 8095 \
    --join true \
    --datastore cockroach \
    --enable-registrations \
    --listen 192.168.0.71 \
    --gossip-peers "192.168.0.71:60010,192.168.0.71:60011,192.168.0.71:60012" \
    --gossip-port 60014 \
    --raft-port 60024

./cropdroid-x64 cluster --debug \
    --data-dir ./db/cluster \
    --log-dir /var/log/cropdroid/cluster \
    --keys keys \
    --ssl=false \
    --port 8096 \
    --join true \
    --datastore cockroach \
    --enable-registrations \
    --listen 192.168.0.71 \
    --gossip-peers "192.168.0.71:60010,192.168.0.71:60011,192.168.0.71:60012" \
    --gossip-port 60015 \
    --raft-port 60025

./cropdroid-x64 cluster --debug \
    --data-dir ./db/cluster \
    --log-dir /var/log/cropdroid/cluster \
    --keys keys \
    --ssl=false \
    --port 8097 \
    --join true \
    --datastore cockroach \
    --enable-registrations \
    --listen 192.168.0.71 \
    --gossip-peers "192.168.0.71:60010,192.168.0.71:60011,192.168.0.71:60012" \
    --gossip-port 60016 \
    --raft-port 60026

 --join true \
--raft "192.168.0.71:60020,192.168.0.71:60021,192.168.0.71:60022" \

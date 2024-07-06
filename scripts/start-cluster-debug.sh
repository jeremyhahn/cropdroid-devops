#!/bin/bash

set -e

FILES="/var/log/cropdroid/cluster/node-1.log /var/log/cropdroid/cluster/node-2.log /var/log/cropdroid/cluster/node-3.log"
sudo mkdir -p /var/log/cropdroid/cluster
sudo touch $FILES
sudo chown $USER $FILES

gnome-terminal -- bash -c '
tmux new-session -d -s CropDroid
tmux new-window c -t CropDroid
tmux send-keys -t CropDroid "./cropdroid cluster --debug \
    --data-dir ./db/cluster \
    --log-dir /var/log/cropdroid/cluster \
    --log-file /var/log/cropdroid/cluster/node-1.log \
    --keys keys \
    --ssl=false \
    --port 8092 \
    --datastore raft \
    --enable-registrations \
    --listen 192.168.1.20 \
    --raft \"192.168.1.20:60020,192.168.1.20:60021,192.168.1.20:60022\"" Enter
tmux split-window -v
tmux send-keys -t CropDroid "./cropdroid cluster --debug \
    --data-dir ./db/cluster \
    --log-dir /var/log/cropdroid/cluster \
    --log-file /var/log/cropdroid/cluster/node-2.log \
    --keys keys \
    --ssl=false \
    --port 8093 \
    --datastore raft \
    --enable-registrations \
    --listen 192.168.1.20 \
    --gossip-peers 192.168.1.20:60010 \
    --gossip-port 60011 \
    --raft \"192.168.1.20:60020,192.168.1.20:60021,192.168.1.20:60022\" \
    --raft-port 60021" Enter
tmux select-window -t CropDroid
tmux -2 attach-session -t CropDroid -d'

sleep 1

gnome-terminal -- bash -c '
tmux new-session -d -s CropClusterLogs
tmux new-window c -t CropClusterLogs
tmux send-keys -t CropClusterLogs "tail -f /var/log/cropdroid/cluster/node-1.log" Enter
tmux split-window -v
tmux send-keys -t CropClusterLogs "tail -f /var/log/cropdroid/cluster/node-2.log" Enter
tmux select-window -t CropClusterLogs
tmux -2 attach-session -t CropClusterLogs -d'
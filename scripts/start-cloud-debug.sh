#!/bin/bash

set -e

FILES="/var/log/cropdroid/cloud/node-1.log /var/log/cropdroid/cloud/node-2.log /var/log/cropdroid/cloud/node-3.log"
sudo mkdir -p /var/log/cropdroid/cloud
sudo touch $FILES
sudo chown $USER $FILES

gnome-terminal -- bash -c '
tmux new-session -d -s CropCloud
tmux new-window c -t CropCloud
tmux send-keys -t CropCloud "./cropdroid-x64 cloud --debug --config-dir ./test --data-dir ./db/cloud --log-dir /var/log/cropdroid/cloud --keys keys --ssl=false --port 9091 --node-id 1 --datastore cockroach --enable-registrations" Enter
tmux split-window -v
tmux send-keys -t CropCloud "./cropdroid-x64 cloud --debug --config-dir ./test --data-dir ./db/cloud --log-dir /var/log/cropdroid/cloud --keys keys --ssl=false --port 9092 --node-id 2 --datastore cockroach --enable-registrations" Enter
tmux select-window -t CropCloud
tmux -2 attach-session -t CropCloud -d'

sleep 1

gnome-terminal -- bash -c '
tmux new-session -d -s CropCloudLogs
tmux new-window c -t CropCloudLogs
tmux send-keys -t CropCloudLogs "tail -f /var/log/cropdroid/cloud/node-1.log" Enter
tmux split-window -v
tmux send-keys -t CropCloudLogs "tail -f /var/log/cropdroid/cloud/node-2.log" Enter
tmux select-window -t CropCloudLogs
tmux -2 attach-session -t CropCloudLogs -d'
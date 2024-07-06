#!/bin/bash

set -e

gnome-terminal -- bash -c '
tmux new-session -d -s CropDroidLogs
tmux new-window c -t CropDroidLogs
tmux send-keys -t CropDroidLogs "docker logs -f cropdroid-d1-n1" Enter
tmux split-window -v
tmux send-keys -t CropDroidLogs "docker logs -f cropdroid-d1-n2" Enter
tmux split-window -v
tmux send-keys -t CropDroidLogs "docker logs -f cropdroid-d1-n3" Enter
tmux select-window -t CropDroidLogs
tmux -2 attach-session -t CropDroidLogs -d'

gnome-terminal -- bash -c '
tmux new-session -d -s CropDroidMasterNode
tmux new-window c -t CropDroidMasterNode
tmux send-keys -t CropDroidMasterNode "docker logs -f cropdroid-d1-n1" Enter
tmux select-window -t CropDroidMasterNode
tmux -2 attach-session -t CropDroidMasterNode -d'

#gnome-terminal -- bash -c '
#tmux new-session -d -s CockroachLogs
#tmux new-window c -t CockroachLogs
#tmux send-keys -t CockroachLogs "docker logs -f roach1" Enter
#tmux split-window -v
#tmux send-keys -t CockroachLogs "docker logs -f roach2" Enter
#tmux split-window -v
#tmux send-keys -t CockroachLogs "docker logs -f roach3" Enter
#tmux select-window -t CockroachLogs
#tmux -2 attach-session -t CockroachLogs -d'

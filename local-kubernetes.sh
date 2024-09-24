#!/bin/sh

SESSION="LocalKubernetes"
SESSIONEXISTS=$(tmux list-sessions | grep $SESSION)

if [ "$SESSIONEXISTS" = "" ]
then
    tmux new-session -d -s $SESSION

    tmux rename-window -t 0 'colima'
    tmux send-keys -t colima 'colima start' Enter 
    tmux send-keys -t colima 'colima status' Enter 

    while ! tmux capture-pane -p -t $WINDOW_A.$PANE_A | grep "colima is running" ; do
        sleep 1
    done ;

    # Create and setup pane for hugo server
    tmux new-window -t $SESSION:1 -n 'minikube'
    tmux send-keys -t minikube 'minikube start' Enter 
    tmux send-keys -t minikube 'minikube logs -f' Enter

    tmux new-window -t $SESSION:2 -n 'CommandPrompt'
    tmux send-keys -t 'CommandPrompt' "nvim" C-m

    # Setup an additional shell
    # tmux new-window -t $SESSION:3 -n 'Shell'
    # tmux send-keys -t 'Shell' "zsh" C-m 'clear' C-m
fi

tmux attach-session -t $SESSION:0
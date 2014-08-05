#!/bin/bash

if [[ -z $1 ]]
then
	SESSION_NAME="default"
else
	SESSION_NAME=$1
fi

POUT=$(tmux has-session -t $SESSION_NAME 2>&1)
if [[ -z $POUT ]]
then
	tmux attach -t $SESSION_NAME
else
	tmux new-session -s $SESSION_NAME
fi

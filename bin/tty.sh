#!/bin/bash

TMUX="/usr/bin/tmux"
if [ -z "$1" ]
then
	echo "Usage $0 name"
	echo "List of actives sessions"
	exec $TMUX list-sessions
	exit 1
fi

HASSESSION=$(/usr/bin/tmux has-session -t $1 2>&1)

if [ "session not found: $1" == "$HASSESSION" ]; then
	NEWSESSION="/usr/bin/tmux new-session -s $1"
	exec $NEWSESSION
else
	ATTACH="/usr/bin/tmux attach-session -t $1"
	exec $ATTACH
fi





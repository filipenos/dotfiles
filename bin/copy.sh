#/bin/sh

xclip -h >/dev/null 2>&1 || sudo apt-get install xclip

exec xclip -selection clipboard "$@"

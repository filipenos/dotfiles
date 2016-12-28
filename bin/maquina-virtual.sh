#/bin/bash

BASEDIR=$(dirname "$0")

if [ -r ~/.maquinarc ]; then
	#echo "reading config file ~/.maquinarc"
	source ~/.maquinarc
else
	echo "config file not found ~/.maquinarc"
	exit 1
fi

function prop {
	if [ ! -z "$1" ]; then
		SERVER="$1"
	elif [ ! -z $2 ]; then
		SERVER="$2"
	else
		echo "SERVER NOT FOUND"
		exit 1
	fi
}

prop "$SERVER" "$server"

PROJECT=$project
ZONE=$zone
USER=$user
HOST="$USER@$SERVER"

function status {
	gcloud compute --project $PROJECT instances list | grep "^$SERVER" | awk '{print $6}'
}

function ip {
	gcloud compute instances list | grep "^$SERVER" | awk '{print $5}'
}

function create {
	echo "starting creation of virtual machine $SERVER"
	gcloud compute --project $PROJECT instances create $SERVER \
	    --zone $ZONE \
	    --machine-type "g1-small" \
	    --metadata-from-file startup-script="$BASEDIR/startup.sh" \
	    --network "default" \
	    --tags "http-server","http-alt","gotty" \
	    --image "/debian-cloud/debian-8-jessie-v20160923" \
	    --boot-disk-size "10" \
	    --boot-disk-type "pd-ssd" \
	    --boot-disk-device-name $SERVER
	echo "done"
}

function start {
	echo "starting virtual machine $SERVER"
	gcloud compute --project $PROJECT instances start $SERVER
	echo "done"
}

function stop {
	echo "stoping virtual machine $SERVER"
	gcloud compute --project $PROJECT instances stop $SERVER
	echo "done"
}

function delete {
	echo "deleting virtual machine $SERVER"
	gcloud compute --project $PROJECT instances delete $SERVER
	echo "done"
}

function ssh {
	if [ -z "$1" ] 
	then
		echo "connectin on virtual machine $SERVER"
		gcloud compute --project $PROJECT ssh --zone $ZONE $HOST
	else
		echo "Execute command '$@' on server $SERVER"
		gcloud compute --project $PROJECT ssh --zone $ZONE $HOST --command  "source /etc/profile; $@"
	fi
}

function output {
	gcloud beta compute --project $PROJECT instances get-serial-port-output $SERVER --zone $ZONE
}

function tty {
	#TODO
	echo "starting tty, connect on ip $(ip)"
	ssh "gotty -a 0.0.0.0 -p 2022 -w -c 'filipe:12345abc' bash"
}

function copyssh {
	echo "Copying ssh key to server $SERVER"
	gcloud compute --project $PROJECT copy-files --zone $ZONE .ssh/id_rsa .ssh/id_rsa.pub $HOST:~/.ssh
	ssh "chmod 400 ~/.ssh/id_rsa"
	ssh "ssh-keyscan bitbucket.org >> ~/.ssh/known_hosts"
	echo "done"
}

function copyto {
	echo "copy $1 > $HOST:$2"
	#gcloud compute --project $PROJECT copy-files --zone $ZONE $1 $HOST:$2
}

function copyfrom {
	echo "copy $HOST:$1 > $t2"
	#gcloud compute --project $PROJECT copy-files --zone $ZONE $HOST:$1 $2
}

function help {
	echo "PROJECT='$PROJECT' ZONE='$ZONE' USER='$USER' SERVER='$SERVER'"
	echo "Usage $0 {status|ip|create|start|stop|delete|ssh|copy-ssh|tty|output|help}"
	exit 0
}

#echo "${*:2}"
#echo "${@:2}"

case "$1" in
	status)
		status
		;;
	ip)
		ip
		;;
	create)
		create
		;;
	start)
		start
		;;
	stop)
		stop
		;;
	delete)
		delete
		;;
	ssh)
		ssh "${*:2}"
		;;
	copy-ssh)
		copyssh
		;;
	output)
		output
		;;
	tty)
		tty
		;;
	copy-to)
		copyto $2 $3
		;;
	copy-from)
		copyfrom "${*:2}"
		;;
	help|*)
		help
		;;
esac

#/bin/bash

BASEDIR=$(dirname "$0")

if [ -r ~/.maquinarc ]; then
	#info "reading config file ~/.maquinarc"
	source ~/.maquinarc
else
	info "config file not found ~/.maquinarc"
	exit 1
fi

function prop {
	if [ ! -z "$1" ]; then
		SERVER="$1"
	elif [ ! -z $2 ]; then
		SERVER="$2"
	else
		info "SERVER NOT FOUND"
		exit 1
	fi
}

prop "$SERVER" "$server"

PROJECT=$project
ZONE=${zone:-us-central1-a}
USER=$user
HOST="$USER@$SERVER"

gcloud_compute() {
        gcloud --project=${PROJECT} compute "$@"
}

describe_instance() {
        gcloud_compute instances describe ${SERVER} --zone=${ZONE} --format yaml
}

instance_status() {
        describe_instance | grep status | awk '{print $2}'
}

instance_ip() {
        describe_instance | grep natIP | awk '{print $2}'
}

instance_output() {
	gcloud_compute instances get-serial-port-output ${SERVER} --zone=${ZONE} 
}

info() {
        echo "[maquina-virtual] $@"
}


function create {
	status=$(instance_status)
	if [[ "$status" == "RUNNING"* ]]; then
		info "server is running, aborting..."
		exit 0
	fi
	
	info "starting creation of virtual machine $SERVER"
	gcloud compute --project $PROJECT instances create $SERVER \
	    --zone $ZONE \
	    --machine-type "g1-small" \
	    --metadata-from-file startup-script=/home/filipe/dotfiles/bin/startup.sh \
	    --network "default" \
	    --tags "http-server","http-alt","gotty" \
	    --image "/debian-cloud/debian-8-jessie-v20160923" \
	    --boot-disk-size "10" \
	    --boot-disk-type "pd-ssd" \
	    --boot-disk-device-name $SERVER
	info "done"
	exit 0
}

function start {
	info "starting virtual machine $SERVER"
	gcloud compute --project $PROJECT instances start $SERVER
	info "done"
}

function stop {
	info "stoping virtual machine $SERVER"
	gcloud compute --project $PROJECT instances stop $SERVER
	info "done"
}

function delete {
	info "deleting virtual machine $SERVER"
	gcloud compute --project $PROJECT instances delete $SERVER
	info "done"
}

function ssh {
	if [ -z "$1" ] 
	then
		info "connectin on virtual machine $SERVER"
		gcloud compute --project $PROJECT ssh --zone $ZONE $HOST
	else
		info "Execute command '$@' on server $SERVER"
		gcloud compute --project $PROJECT ssh --zone $ZONE $HOST --command  "source /etc/profile; $@"
	fi
}

function tty {
	#TODO
	info "starting tty, connect on ip $(ip)"
	ssh "gotty -a 0.0.0.0 -p 2022 -w -c 'filipe:12345abc' bash"
}

function copyssh {
	info "Copying ssh key to server $SERVER"
	gcloud compute --project $PROJECT copy-files --zone $ZONE ~/.ssh/id_rsa ~/.ssh/id_rsa.pub $HOST:~/.ssh
	ssh "chmod 400 ~/.ssh/id_rsa"
	ssh "ssh-keyscan bitbucket.org >> ~/.ssh/known_hosts"
	info "done"
}

function copyto {
	info "copy $1 > $HOST:$2"
	#gcloud compute --project $PROJECT copy-files --zone $ZONE $1 $HOST:$2
}

function copyfrom {
	info "copy $HOST:$1 > $t2"
	#gcloud compute --project $PROJECT copy-files --zone $ZONE $HOST:$1 $2
}

function help {
	echo "PROJECT='$PROJECT' ZONE='$ZONE' USER='$USER' SERVER='$SERVER'"
	echo "Usage $0 {status|ip|create|start|stop|delete|ssh|copy-ssh|tty|output|help}"
	exit 0
}

case "$1" in
	status)
		instance_status
		;;
	ip)
		instance_ip
		;;
	output)
		instance_output
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
exit 0

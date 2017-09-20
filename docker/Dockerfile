FROM debian:stretch

MAINTAINER Filipe Peixoto <filipenos@gmail.com>

# Some Environment Variables
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -qqy update && apt-get install -qqy --no-install-recommends \
        vim zsh git tmux wget curl unzip \
        sudo gcc make build-essential bash-completion command-not-found \
        ca-certificates lsb-release apt-transport-https gnupg \
    openjdk-8-jre openjdk-8-jdk openjdk-8-jdk-headless && \
    export CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)" && \
    echo "deb https://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" > /etc/apt/sources.list.d/google-cloud-sdk.list && \
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
    apt-get -qyy update && \
    apt-get install -qqy \
	google-cloud-sdk google-cloud-sdk-app-engine-go && \
    apt-get autoremove -qqy && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN useradd -ms /bin/bash dev
USER dev
WORKDIR /home/dev

RUN wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true

RUN wget https://storage.googleapis.com/golang/go1.8.3.linux-amd64.tar.gz -O /tmp/go.tar.gz && \
    mkdir -p /home/dev/lib && \
    tar xvf /tmp/go.tar.gz -C /home/dev/lib

ENV GOROOT="/home/dev/lib/go"
ENV PATH="${PATH}:${GOROOT}/bin:${HOME}/go/bin"

ENTRYPOINT ["/usr/bin/zsh"]

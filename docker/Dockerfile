FROM debian:jessie

MAINTAINER Filipe Peixoto <filipenos@gmail.com>

# Some Environment Variables
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get upgrade -y && apt-get dist-upgrade -y
RUN apt-get install -y --no-install-recommends \
	    zsh bash tmux curl wget python git \
	    ca-certificates unzip

RUN wget https://storage.googleapis.com/golang/go1.6.4.linux-amd64.tar.gz -O /tmp/go.tar.gz && \
	    tar xvf /tmp/go.tar.gz -C /usr/lib

RUN wget https://storage.googleapis.com/appengine-sdks/featured/go_appengine_sdk_linux_amd64-1.9.58.zip -O /tmp/go_appengine.zip && \
	    unzip /tmp/go_appengine.zip -d /usr/lib

RUN apt-get autoclean -y && apt-get autoremove -y && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN useradd -ms /bin/bash dev
USER dev
WORKDIR /home/dev

RUN wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true

ENV GOROOT="/usr/lib/go"
ENV PATH="${PATH}:${GOROOT}/bin"
ENV GOPATH="${HOME}/go"
ENV PATH="${PATH}:{$GOPATH}/bin"
ENV GAESDK="/usr/lib/go_appengine"
ENV PATH="${PATH}:${GAESDK}/goroot-1.6/bin"

ENTRYPOINT ["/usr/bin/zsh"]

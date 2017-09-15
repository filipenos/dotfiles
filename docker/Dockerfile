FROM debian:jessie

MAINTAINER Filipe Peixoto <filipenos@gmail.com>

RUN apt-get update && apt-get upgrade -y && apt-get dist-upgrade -y
RUN apt-get install -y --no-install-recommends \
	    zsh bash curl wget python git \
	    ca-certificates unzip
RUN apt-get autoclean -y && apt-get autoremove -y

RUN useradd -ms /bin/bash filipe

USER filipe
WORKDIR /home/filipe

RUN mkdir /home/filipe/lib

RUN wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true

RUN wget https://storage.googleapis.com/golang/go1.6.4.linux-amd64.tar.gz -O /tmp/go.tar.gz && \
	    tar xvf /tmp/go.tar.gz -C /home/filipe/lib

RUN wget https://storage.googleapis.com/appengine-sdks/featured/go_appengine_sdk_linux_amd64-1.9.58.zip -O /tmp/go_appengine.zip && \
	    unzip /tmp/go_appengine.zip -d /home/filipe/lib

ENV PATH="${PATH}:/home/filipe/lib/go/bin"

ENTRYPOINT ["/usr/bin/zsh"]

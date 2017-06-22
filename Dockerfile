FROM ubuntu:xenial
RUN apt-get update
RUN apt-get install -y software-properties-common && add-apt-repository -y ppa:longsleep/golang-backports
RUN apt-get update
RUN apt-get install -y make golang-go mercurial libcairo2-dev ruby-dev build-essential git && gem install fpm

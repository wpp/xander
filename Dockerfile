FROM ubuntu:14.04

MAINTAINER Philipp Weissensteiner <mail@philippweissensteiner.com>

# VERSION: 0.0.1

# To avoid a lot of "debconf: unable to initialize frontend: Dialog"
# https://github.com/phusion/baseimage-docker/issues/58
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections &&\
    echo "deb http://archive.ubuntu.com/ubuntu $(lsb_release -sc) main restricted universe" > /etc/apt/sources.list &&\
    echo "deb http://archive.ubuntu.com/ubuntu $(lsb_release -sc)-updates main restricted universe" >> /etc/apt/sources.list &&\
    echo "deb http://archive.ubuntu.com/ubuntu $(lsb_release -sc)-security main restricted universe" >> /etc/apt/sources.list &&\
    apt-get update &&\
    apt-get -y upgrade &&\
    apt-get -y install software-properties-common &&\
    apt-get -y install build-essential zlib1g-dev libssl-dev libreadline6-dev nodejs &&\
    apt-get -y install wget curl vim-tiny git supervisor libsqlite3-dev &&\
    apt-get -y install nginx libpq-dev &&\
    apt-get -y update &&\
    apt-get clean

# Ruby and bundler
RUN echo 'gem: --no-document' >> /usr/local/etc/gemrc &&\
    mkdir /src && cd /src && git clone https://github.com/sstephenson/ruby-build.git &&\
    cd /src/ruby-build && ./install.sh &&\
    cd / && rm -rf /src/ruby-build && ruby-build 2.2.3 /usr/local &&\
    gem update --system &&\
    gem install bundler

ADD config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

ENV RAILS_ENV production
WORKDIR /ruby-app
# Avoid bundle installing if the Gemfile did not change
ADD ruby-app/Gemfile Gemfile
ADD ruby-app/Gemfile.lock Gemfile.lock
RUN bundle install
ADD ruby-app/ /ruby-app

RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

ENTRYPOINT ["supervisord"]

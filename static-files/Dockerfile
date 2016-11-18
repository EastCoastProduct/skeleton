FROM ubuntu:14.04

RUN apt-get update \
  && apt-get install software-properties-common python-software-properties -y \
  && add-apt-repository ppa:adiscon/v8-stable -y \
  && apt-get install rsyslog -y \
  && apt-get install curl -y \
  && curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash - \
  && (export DEBIAN_FRONTEND=noninteractive; apt-get install nodejs -y) \
  && useradd --user-group --create-home --shell /bin/bash app \
  && mkdir /home/app/src \
  && rm -rf /var/cache/* \
  && rm -f /etc/rsyslog.d/* \
  && touch /var/log/json \
  && touch /var/log/normal

COPY . /home/app/src
COPY rsyslog/rsyslog.conf /etc/rsyslog.conf
WORKDIR /home/app/src
RUN chmod 767 docker-start.sh

ARG base=master
FROM phusion/baseimage:$base

LABEL maintainer=docker-maint+x-sagan@dotmpe.com

ENV CFLAGS="-Wall -Wno-unused-parameter -Wno-unused-function"


      #libgnutls-dev 
ARG MAINPACKAGES=""
ARG DEVPACKAGES="build-essential checkinstall automake autoconf git \
      libevent-dev \
      libhiredis-dev \
      libjson-c-dev \
      libmaxminddb-dev \
      libyaml-dev libzip-dev"

RUN apt-get update -qq && \
  DEBIAN_FRONTEND=noninteractive RUNLEVEL=1 \
  apt-get install -qqy $MAINPACKAGES $DEVPACKAGES


ARG meer_version=main
ARG meer_agflags=""
#ARG meer_cflags="--enable-redis --enable-elasticsearch --enable-geoip"
ARG meer_cflags="--enable-gzip --enable-redis --enable-geoip"

# XXX: use version just before syslog support
RUN \ 
  echo "Getting Meer..." && \
  cd /usr/local/src && \
  git clone https://github.com/quadrantsec/meer -b ${meer_version} && \
    \
  cd /usr/local/src/meer && \
  git checkout 956c7520ee3a67204446560c787b3f47fb9076d7 && \
  ./autogen.sh $meer_agflags && \
  ./configure $meer_cflags && \
  make

# TODO: now keep etc/meer.yaml and (src/)meer and stuff into container
# but keeping this image for now
RUN \ 
  echo "Installing Meer into build image..." && \
  cd /usr/local/src/meer && \
  make install

# XXX: default config runs as suricata, change
RUN \
  mkdir -p /var/log/meer && \
  chmod -R g+rw /var/log/meer && \
  \
  mkdir -p /var/log/suricata && \
  useradd suricata --shell /sbin/nologin --home / && \
  touch /var/log/suricata/alert.json && \
  chmod -R g+rw /var/log/suricata && \
  chown -R nobody:suricata /var/log/meer && \
  chown -R nobody:suricata /var/log/suricata && \
  true

ENTRYPOINT /usr/local/bin/meer
#

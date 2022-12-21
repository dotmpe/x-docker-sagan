# The oldest phusion Ubuntu is Bionic, which is too new for ELSA installer
#ARG base=bionic-1.0.0
#FROM phusion/baseimage:$base

FROM ubuntu:trusty

LABEL maintainer=docker-maint+x-sagan@dotmpe.com

ARG elsa_version=master

RUN apt-get update -qq && \
  DEBIAN_FRONTEND=noninteractive RUNLEVEL=1 \
  apt-get install -qqy git apache2-mpm-prefork && \
    \ 
  echo "Installing ELSA..." && \
  cd /usr/local/src && \
  git clone https://github.com/mcholste/elsa.git -b ${elsa_version} && \
  cd /usr/local/src/elsa && \
  sh -c "sh contrib/install.sh node && sh contrib/install.sh web"

#

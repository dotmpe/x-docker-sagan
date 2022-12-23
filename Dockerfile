ARG base=master
FROM phusion/baseimage:$base

LABEL maintainer=docker-maint+x-sagan@dotmpe.com

ARG MAINPACKAGES="libpcre3 libdumbnet1 libjson-c4 libuuid1 libpcap0.8 \
      sqlite3 libcurl3-gnutls curl libmaxminddb0 libesmtp6 libfastjson4 \
      libestr0 libyaml-0-2 liblognorm5"

ARG DEVPACKAGES="build-essential checkinstall automake autoconf \
      pkg-config libtool git procps libpcre3-dev libdumbnet-dev libpcap-dev \
      libjson-c-dev libcurl4-gnutls-dev dh-autoreconf uuid-dev libsqlite3-dev \
      libmaxminddb-dev libesmtp-dev libfastjson-dev libestr-dev libyaml-dev \
      libbsd-dev liblognorm-dev"

ARG sagan_agflags=""
ARG sagan_cflags="--prefix=/usr --sysconfdir=/etc --disable-libpcap --enable-syslog --enable-system-strstr"
ENV prefix=/usr
ENV sysconfdir=/etc

ARG sagan_version=main

RUN apt-get update -qq && \
  DEBIAN_FRONTEND=noninteractive RUNLEVEL=1 \
  apt-get install -qqy $MAINPACKAGES $DEVPACKAGES && \
    \ 
  echo "Installing Sagan..." && \
  cd /usr/local/src && \
  git clone https://github.com/quadrantsec/sagan -b ${sagan_version} && \
    \
  cd /usr/local/src/sagan && \
  ./autogen.sh $sagan_agflags && \
  ./configure $sagan_cflags && \
  make && \
  make install && \
  cp /usr/local/src/sagan/etc/sagan.yaml ${sysconfdir:?}/sagan.yaml && \
  mkdir -p /var/log/sagan && \
  mkdir -p /var/run/sagan && \
  useradd sagan --shell /sbin/nologin --home / && \
  chown -R nobody:sagan /var/log/sagan && \
  chown -R nobody:sagan /var/run/sagan && \
    \
  echo "Done, Cleaning up" && \
  apt-get purge -qqy man $DEVPACKAGES && \
  apt-get clean autoclean && \
  apt-get autoremove -qqy && \
  rm -Rf /usr/local/src/* -Rf && \
  rm -Rf /tmp/* && \
  rm -Rf /var/lib/apt/lists/*.gz && \
  rm -Rf /var/lib/cache/* && \
  rm -Rf /var/lib/log/* && \
  rm -Rf /var/log/* && \
  rm -Rf /var/cache/*

COPY docker/sagan.sh /root/run.sh 

COPY docker/etc-my_initd-20_sagan.init /etc/my_init.d/20_sagan.init
#COPY docker/etc-my_initd-20_sagan.shutdown /etc/my_init.post_shutdown.d/20_sagan.shutdown

COPY docker/etc-syslog-ng-confd-10-sagan-pipe.conf /etc/syslog-ng/conf.d/10-sagan-pipe.conf

#COPY docker/etc-syslog-ng-confd-10-sagan-json.conf /etc/syslog-ng/conf.d/10-sagan-json.conf
#ENV input_type=json
#ENV json_software=syslog-ng
#ENV json_map=${sysconfdir:?}/sagan-rules/json-input.map


RUN sed -i 's/use_dns.no./use_dns(yes)/' /etc/syslog-ng/syslog-ng.conf
#RUN sed -i 's/dns_cache.no./dns_cache(yes)/' /etc/syslog-ng/syslog-ng.conf
#RUN sed -i 's/use_fqdn.no./use_fqdn(yes)/' /etc/syslog-ng/syslog-ng.conf
RUN sed -i 's/long_hostnames.no./long_hostnames(yes)/' /etc/syslog-ng/syslog-ng.conf
RUN sed -i 's/chain_hostnames/keep_hostname(yes); chain_hostnames/' /etc/syslog-ng/syslog-ng.conf


EXPOSE 514/udp

# phusion/baseimage init handles starting rsyslog. To read fifo only sagan can
# be started without help of my_init
#ENTRYPOINT ["/root/run.sh"]

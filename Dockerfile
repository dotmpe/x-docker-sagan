ARG base=master
FROM phusion/baseimage:$base

LABEL maintainer=docker-maint@dotmpe.com

ARG MAINPACKAGES="libpcre3 libdumbnet1 libjson-c3 libuuid1 libpcap0.8 \
      sqlite3 libcurl3-gnutls curl libmaxminddb0 libesmtp6 libfastjson4 \
      libestr0 libyaml-0-2 liblognorm5"

ARG DEVPACKAGES="build-essential checkinstall automake autoconf \
      pkg-config libtool git procps libpcre3-dev libdumbnet-dev libpcap-dev \
      libjson-c-dev libcurl4-gnutls-dev dh-autoreconf uuid-dev libsqlite3-dev \
      libmaxminddb-dev libesmtp-dev libfastjson-dev libestr-dev libyaml-dev \
      libbsd-dev liblognorm-dev"

#ARG sagan_cflags="--disable-libdnet --disable-libpcap --enable-geoip2 --disable-snortsam --disable-syslog --enable-system-strstr"
ARG sagan_cflags="--disable-libdnet --disable-libpcap --enable-geoip2 --disable-snortsam --enable-syslog --enable-system-strstr"

RUN apt-get update -qq && \
  DEBIAN_FRONTEND=noninteractive RUNLEVEL=1 \
  apt-get install -qqy $MAINPACKAGES $DEVPACKAGES && \
    \
  mkdir -p /usr/share/GeoIP && \
  cd /usr/share/GeoIP && \
  curl -z Geo-Country.mmdb.gz --silent --location -o Geo-Country.mmdb.gz http://geolite.maxmind.com/download/geoip/database/GeoLite2-Country.mmdb.gz && \
  gzip -fqdk /usr/share/GeoIP/Geo-Country.mmdb.gz && \
    \ 
  cd /usr/local/src && \
  git clone https://github.com/beave/sagan -b master && \
    \
  cd /usr/local/src/sagan && \
  ./autogen.sh $sagan_cflags && \
  ./configure $sagan_cflags && \
  make && \
  make install && \
  cp /usr/local/src/sagan/etc/sagan.yaml /usr/local/etc/sagan.yaml && \
    \
  mkdir -p /var/log/sagan && \
  mkdir -p /var/run/sagan && \
  useradd sagan --shell /sbin/nologin --home / && \
  chown -R nobody:sagan /var/log/sagan && \
  chown -R nobody:sagan /var/run/sagan && \
    \
  apt-get purge -qqy man $DEVPACKAGES && \
  apt-get clean autoclean && \
  apt-get autoremove -qqy && \
  rm -Rf /tmp/* && \
  rm -Rf /usr/local/src/* -Rf && \
  rm -Rf /var/lib/apt/lists/*.gz && \
  rm -Rf /var/lib/cache/* && \
  rm -Rf /var/lib/log/* && \
  rm -Rf /var/log/* && \
  rm -Rf /var/cache/*

COPY docker/run.sh /root/run.sh 
COPY docker/etc-rsyslogd-10-sagan-pipe.conf /etc/rsyslog.d/10-sagan-pipe.conf

#VOLUME /usr/local/etc/sagan.yaml

ENTRYPOINT ["/root/run.sh"]

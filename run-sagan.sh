set -eu
#test -d ../sagan-rules && {
#  ( cd ../sagan-rules && git pull ) || exit
#} || {
#  git clone http://github.com/quadrantsec/sagan-rules ../sagan-rules
#}
cp config_data ../sagan-rules/
: ${default_host:=192.168.3.151}
: "${base:=master}"
: "${sagan_version:=v,2,0.2}"
#: "${sagan_version:=main}"
: "${domain:=$(hostname -f)}"
: "${domain:=localhost.localdomain}"
: "${sensor_name:=sagan-t470p}"
# Lower lost-client alert delay from 12h to 1h
trackclients=60
# XXX: default_host should be IP addr I think
docker build . \
  -t sagan-dev:baseimage-$base \
  --build-arg base=$base \
  --build-arg sagan_version=$sagan_version
docker run -ti --rm \
  --name sagan_dev \
  --hostname sagan-dev.${domain} \
  --env default_host=$default_host \
  --env trackclients=$trackclients \
  --env sensor_name=$sensor_name \
	-p 5514:514/udp \
  -v $PWD/sagan-logs:/var/log/sagan \
  -v $PWD/../sagan-rules:/usr/local/etc/sagan-rules \
  sagan-dev:baseimage-$base
  # "$@"

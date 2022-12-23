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
: "${cluster_name:=sagan-lab}"
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
  --env cluster_name=$cluster_name \
  --add-host un.wtwta.org:10.147.17.19 \
  --add-host un:10.147.17.19 \
  --add-host gw:192.168.3.1 \
  --add-host t470p:192.168.3.151 \
  --add-host t460s:192.168.3.162 \
  --add-host opi:192.168.3.182 \
	-p 5514:514/udp \
  -v $PWD/sagan-logs:/var/log/sagan \
  -v $PWD/../sagan-rules:/etc/sagan-rules \
  sagan-dev:baseimage-$base
  # "$@"

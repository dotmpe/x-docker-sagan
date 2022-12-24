set -eu
. ./_lib.sh

#saganrules
cp config_data ../sagan-rules/
: "${base:=master}"
: "${sagan_version:=v,2,0.2}"
#: "${sagan_version:=main}"
# XXX: default_host should be IP addr I think
docker build . \
  -f SyslogNG.Dockerfile \
  -t sagan-dev:baseimage-$base \
  --build-arg base=$base \
  --build-arg sagan_version=$sagan_version

# Container vars
: "${domain:=$(hostname -f)}"
#: "${domain:=localhost.localdomain}"

# Params
: "${default_host:=$(hostname -I|cut -d' ' -f1)}"
: "${sensor_name:=sagan-$(hostname -s)}"
: "${cluster_name:=sagan-lab}"
: "${source_lookup:="enabled"}"
: "${dns_warnings:="enabled"}"
# Lower lost-client alert delay from 12h to 1h
trackclients=60
saganhosts
addhosts=$(addhosts < ./hosts)

echo "Starting Sagan... ($0 $*)"
echo "sensor-name: $sensor_name"
echo "cluster-name: $cluster_name"
echo "default-host: $default_host"
docker run -ti --rm \
  --name sagan_dev \
  --hostname sagan-dev.${domain} \
  --env default_host=$default_host \
  --env trackclients=$trackclients \
  --env sensor_name=$sensor_name \
  --env cluster_name=$cluster_name \
	--network host \
  $addhosts \
	-p 5514:514/udp \
  -v $PWD/sagan-logs:/var/log/sagan \
  -v $PWD/../sagan-rules:/etc/sagan-rules \
  sagan-dev:baseimage-$base
  # "$@"

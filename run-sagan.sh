set -e
test -d ../sagan-rules || {
  git clone http://github.com/beave/sagan-rules ../sagan-rules
  cp config_ddata ../sagan-rules/
}
#: ${HOME_COUNTRY:="[NL]"}
#: ${default_host:=192.168.9.31}
#  --env default_host=$default_host \
: ${base:=master}
: ${domain:=localhost.localdomain}
docker build . \
  -t sagan-dev:baseimage-$base \
  --build-arg base=$base
docker run -ti --rm \
  --name sagan_dev \
  --hostname sagan-dev.${domain} \
  --env input_type=pipe \
  --env HOME_COUNTRY=$HOME_COUNTRY \
  -v $PWD/sagan-logs:/var/log/sagan \
  -v $PWD/../sagan-rules:/usr/local/etc/sagan-rules \
  sagan-dev:baseimage-$base

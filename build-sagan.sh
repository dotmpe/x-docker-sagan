set -eu

. ./conf-sagan.sh

#saganrules
cp config_data ../sagan-rules/

docker build . \
  -f SyslogNG.Dockerfile \
  -t sagan-dev:baseimage-$base \
  --build-arg base=$base \
  --build-arg sagan_version=$sagan_version


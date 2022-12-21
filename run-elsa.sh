set -eu
base=trusty
docker build . \
  -f ELSA.Dockerfile \
  -t sagan-elsa-dev:baseimage-$base \
  --build-arg elsa_version=master
docker run -ti --rm \
  --name elsa_dev \
  sagan-elsa-dev:baseimage-$base "$@"
#

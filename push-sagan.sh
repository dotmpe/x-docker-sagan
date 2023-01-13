set -eu
. ./_lib.sh
. ./build-sagan.sh

# XXX: get rid of the comma
sagan_version=2.0.2
commit_tag=$sagan_version-$base

docker tag sagan-dev:baseimage-$base \
  dotmpe/sagan-dev:$commit_tag

echo pushing $commit_tag... >&2
docker push \
  dotmpe/sagan-dev:$commit_tag
#

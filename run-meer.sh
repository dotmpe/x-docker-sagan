set -eu
base=master
: "${domain:=$(hostname -f)}"

docker build . \
  -f Meer.Dockerfile \
  -t sagan-meer:baseimage-$base \
  --build-arg meer_version=main

#evelog=/srv/project-local/x-docker-sagan/sagan-logs/eve.json
evelog=/srv/project-local/x-docker-sagan/sagan-logs/stats/client-stats.json

classconf=/src/project-local/sagan-rules/classification.config

docker run -ti \
  --name meer_dev \
  --rm \
  --workdir / \
  --hostname meer-dev.${domain} \
  -v $PWD/meer.yaml:/etc/meer.yaml \
  -v $PWD/meer.yaml:/usr/local/etc/meer.yaml \
  -v $PWD/meer-logs:/var/log/meer \
  -v $evelog:/var/log/suricata/alert.json \
  -v $classconf:/etc/classification.config \
  sagan-meer:baseimage-$base

#

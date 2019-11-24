test -d ../sagan-rules || {
  git clone http://github.com/beave/sagan-rules ../sagan-rules
  cp config_ddata ../sagan-rules/
}
docker build . -t sagan-dev
docker run -ti --rm \
  --env default_host=192.168.9.31 \
  --env input_type=pipe \
  -v $PWD/sagan-logs:/var/log/sagan \
  -v $PWD/../sagan-rules:/usr/local/etc/sagan-rules \
  sagan-dev

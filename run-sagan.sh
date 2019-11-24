sudo rm -rf /var/run/sagan.fifo
sudo mkfifo /var/run/sagan.fifo
: ${dckr_tag:=defensative-1.8}
docker run -ti --rm \
  --env default_host=192.168.9.31 \
  --env input_type=pipe \
  -v $PWD/docker/run.sh:/root/run.sh \
  -v $PWD/sagan-logs:/var/log/sagan \
  -v $PWD/../sagan-rules:/usr/local/etc/sagan-rules \
  -v $PWD/docker/hosts:/etc/hosts \
  -v /var/run/sagan.fifo:/var/run/sagan.fifo \
  defensative/def-sagan:$dckr_tag

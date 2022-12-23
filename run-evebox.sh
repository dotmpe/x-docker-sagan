
# This rocks!

docker pull jasonish/evebox:latest

docker run -it \
  --name evebox_dev \
  --rm \
  -p 5636:5636 \
  -v $PWD/sagan-logs/eve.json:/var/log/eve.json \
  jasonish/evebox:latest \
  -D . --database sqlite --input /var/log/eve.json

#

docker run \
  --rm \
  -d \
  --name run-memcached \
  -p 11211:11211 \
  memcached:alpine

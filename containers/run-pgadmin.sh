docker run \
  --rm \
  --detach \
  --name "run-pgadmin" \
  --publish 8090:80 \
  -e "PGADMIN_DEFAULT_EMAIL=filipenos@gmail.com" \
  -e "PGADMIN_DEFAULT_PASSWORD=filipe" \
  -v "pgadmin-data:/var/lib/pgadmin" \
  dpage/pgadmin4:latest

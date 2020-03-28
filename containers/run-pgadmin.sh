docker run \
  --rm \
  --detach \
  --name "run-pgadmin" \
  -p 8090:80 \
  -e "PGADMIN_DEFAULT_EMAIL=filipenos@gmail.com" \
  -e "PGADMIN_DEFAULT_PASSWORD=filipe" \
  -v "gadmin-data:/var/lib/pgadmin" \
  dpage/pgadmin4:latest

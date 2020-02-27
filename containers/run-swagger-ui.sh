docker run \
  --rm \
  -d \
  --name run-swagger-ui \
  -p 8080:8080 \
  swaggerapi/swagger-ui

#docker run -p 80:8080 -e SWAGGER_JSON=/foo/swagger.json -v /bar:/foo swaggerapi/swagger-ui
#docker run -p 80:8080 -e BASE_URL=/swagger -e SWAGGER_JSON=/foo/swagger.json -v /bar:/foo swaggerapi/swagger-ui

docker build -t civetweb-binary .
docker create --name civetweb-container civetweb-binary
docker cp civetweb-container:/build/civetweb/build/src/civetweb ./
docker rm civetweb-container

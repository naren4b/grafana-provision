# grafana-provision
Create your own grafana image and provision dashboard and data sources

```
IMAGE_NAME= grafana7
VERSION_PREFIX=$date +%s
BUILD_NUMBER=1
WORKSPACE=grafana

docker build -t ${IMAGE_NAME}:${VERSION_PREFIX}${BUILD_NUMBER} ${WORKSPACE} -f Dockerfile
```


# grafana-provision
Create your own grafana image and provision dashboard and data sources

```bash
docker build -t <private-repo>/grafana:<version> -f Dockerfile .
docker push <private-repo>/grafana:<version>
```

The image provisions green and blue dashboard folders together. Replace the
sample Prometheus URLs in datasources/ with your endpoints before building.
Green remains the default data source; blue uses prometheus-blue.

Green sample:

![Green dashboard](/img/green.PNG)


Blue sample:

![Blue dashboard](/img/blue.PNG)

# grafana-provision
Create your own grafana image and provision dashboard and data sources

```
docker build -t <private-repo>/grafana:<version> -f Dockerfile .

docker push  <private-repo>/grafana:<version>

```

Once tried with green project only You will see this dashboards

![Green dashboard](/img/green.PNG)


Once tried with blue project only You will see this dashboards

![Blue dashboard](/img/blue.PNG)

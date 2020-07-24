FROM grafana/grafana:7.0.0
USER root

COPY grafana.ini /etc/grafana/

RUN mkdir -p /var/grafana/dashboards/green
COPY config/green/*.yml /etc/grafana/provisioning/dashboards/
COPY datasources/green/*.yml /etc/grafana/provisioning/datasources/
COPY dashboards/green/*.json /var/grafana/dashboards/green/


RUN mkdir -p /var/grafana/dashboards/blue
COPY config/blue/*.yml /etc/grafana/provisioning/dashboards/
COPY datasources/blue/*.yml /etc/grafana/provisioning/datasources/
COPY dashboards/blue/*.json /var/grafana/dashboards/blue/



# Install plugin in Image building
RUN grafana-cli --pluginsDir=/var/grafana/plugins plugins install grafana-piechart-panel

# Copy the Custom plugins(downloaded and customised)
RUN mkdir -p /var/grafana/plugins/
COPY plugins/algenty-grafana-flowcharting /var/grafana/plugins/

ENV GF_PATHS_PLUGINS="/var/grafana/plugins"

USER grafana

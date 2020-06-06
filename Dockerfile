FROM grafana/grafana:6.3.2
USER root

COPY config/grafana.ini /etc/grafana

RUN mkdir -p /var/grafana/dashboards/project-green
COPY project-green/config/*.yml /etc/grafana/provisioning/dashboards/
COPY project-green/datasources/*.yml /etc/grafana/provisioning/datasources/
COPY project-green/dashboards/*.json /var/grafana/dashboards/project-green/


# Install plugin in Image building
RUN grafana-cli --pluginsDir=/var/grafana/plugins plugins install grafana-piechart-panel

# Copy the Custom plugins(downloaded)
RUN mkdir -p /var/grafana/plugins/grafana-worldmap-panel
COPY project-green/plugins/* /var/grafana/plugins/

ENV GF_PATHS_PLUGINS="/var/grafana/plugins"

USER grafana

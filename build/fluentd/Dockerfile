FROM fluent/fluentd:v1.14-debian-1
USER root
RUN ["fluent-gem", "install", "elasticsearch", "--version", "7.14.0"]
RUN ["fluent-gem", "install", "elasticsearch-transport", "--version", "7.14.1"]
RUN ["fluent-gem", "install", "fluent-plugin-elasticsearch"]
RUN mkdir -p /var/log/fl/ \
  && chown fluent:fluent /var/log/fl 

COPY fluent.conf /fluentd/etc
  
USER fluent


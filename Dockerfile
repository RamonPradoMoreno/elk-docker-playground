FROM docker.elastic.co/logstash/logstash:7.6.1

RUN /usr/share/logstash/bin/logstash-plugin install logstash-output-gelf

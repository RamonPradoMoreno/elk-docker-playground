# Elk stack playground

*Source*: This project was started by **jtoledano** you can find his work at [github](https://github.com/JulianToledano/monitoring-quarkus-apps). At some point I started to focus more on docker and since our work diverged I decided to post it here. We are still collaborating though. :happy:

[ELK](https://www.elastic.co/what-is/elk-stack) is the acronym of ElasticSearch, Logstash and Kibana. The core of elastic.

This document builds a ELK ecosystem only using only public images available in [hub.docker.com](hub.docker.com). Each of the different approaches slowly adds complexity to the system so we can improve our understanding of it.

## Components

### ElasticSearch

[ElasticSearch](https://www.elastic.co/) is a search and analytics engine. It contains all the logs and can process it.

### Logstash

[Logstash](https://www.elastic.co/logstash) is a data collection engine that can collect data from different [sources](https://www.elastic.co/guide/en/logstash/current/input-plugins.html) and output them to your choosen [stash](https://www.elastic.co/guide/en/logstash/current/input-plugins.html).

In this case we'll use just the [gelf plugin](https://www.elastic.co/guide/en/logstash/current/plugins-inputs-gelf.html) as the input and [elasticsearch server](https://www.elastic.co/guide/en/logstash/current/plugins-outputs-elasticsearch.html) as output. You can check this configuration in the [gelf.com](logstash/pipelines/gelf.com)

Our logstash config was obtained from a [kuarkus tutorial](https://quarkus.io/guides/centralized-log-management#send-logs-to-logstash-the-elastic-stack-elk) and is in `conf/logstash/gelf.com`:

```
input {
  gelf {
    port => 12201
  }
}
output {
  stdout {}
  elasticsearch {
    hosts => ["http://elasticsearch:9200"]
  }
}

```

### Kibana

[Kibana](https://www.elastic.co/kibana) is a frontend application that sits on top of the Elastic Stack, providing search and data visualization capabilities for data indexed in Elasticsearch.  Mainly used for **monitoring** apps and logs.

You can check your kibana dashboard [here](localhost:5601).

**Note**: kibana takes from 1 to 5 minute to get up, so don't get nervous if it seems that doesn't work at the beggining.

Our kibana config is in `conf/kibana/kibana.yaml`:

```yaml
# Defaults for running in a container
# More info: https://www.elastic.co/guide/en/kibana/current/docker.html

server.name: "kibana"
server.host: "0"
elasticsearch.hosts: "http://elasticsearch:9200"
xpack.monitoring.ui.container.elasticsearch.enabled: true
```

### log-to-elk-microservice

This is a basic microservice that sends data to a logstash node.

It has a rest endpoint: `/hello` that can be accessed with the following curl:

```bash
curl localhost:8080/hello
```

The microservice gathers metrics for the above method and sends a `DEBUG` and an `INFO` trace per call. 

## Initial approach: At least it works

We built a `docker-compose.yaml` with the minimal configuration to work. It also exposes all ports in case we need to execute an application in `localhost`. To use it you need to: 

```bash
docker-compose up -d
```

You also need to have the following directories and config files:

```
├── conf
│   ├── kibana
│   │   └── kibana.yml
│   └── logstash
│       └── gelf.com
└── docker-compose.yaml
```

Our docker-compose is:

```yaml
version: '3.7'
services: 
    elasticsearch:
        image: elasticsearch:7.6.1
        container_name: elasticsearch
        ports: 
            # Logstash sends data here because of logstash/pipelines/gelf.com
            - 9200:9200
            # Unknown
            - 9300:9300
        networks: 
            - elk_net
        environment: 
            - discovery.type=single-node
    logstash:
        image: docker.elastic.co/logstash/logstash:7.6.1
        container_name: logstash
        ports:
            # Unknown
            - 5000:5000
            # Gets basic data about logstash node
            - 9600:9600
            # Apps send logs here, not needed 
            # if logs are coming from a container
            - 12201:12201/udp
        networks: 
            - elk_net
        volumes: 
            - ./conf/logstash:/usr/share/logstash/pipeline
        depends_on: 
            -  elasticsearch
    kibana:
        image: docker.elastic.co/kibana/kibana:7.6.1
        container_name: kibana
        ports: 
            # Kibana interface
            - 5601:5601
        networks: 
            - elk_net
        volumes: 
            - ./conf/kibana:/usr/share/kibana/config/
        depends_on: 
            - logstash
    log-to-elk:
        # This is a simple microservice that sends
        # data to logstash when it receives a GET request.
        image: rpardom/log-to-elk-microservice
        container_name: log-to-elk
        ports: 
            # To receive the curls for logs generation
            - 8080:8080
        networks: 
            - elk_net

networks: 
    elk_net:
        driver: bridge


```

### Testing it

1. Go into the *Kibana* app at http://localhost:5601.

2. Go to discover (second option of left toolbar) 

3. Create a index pattern called: `logstash*`

4. In the next screen choose `@timestap`

5. Once you are done, send a request to the microservice with:

   ```bash
   curl localhost:8080/hello
   ```

6. Reload the page and you will see the log of `INFO` level sent by your microservice.

## Second approach: Now data is persisted

The next step was persisting our logs in order to guarantee that our system can survive a `docker container stop` or even a `docker-compose down`. In order to do so we added  a new directory `/logs` and synced it with the right containers dir: `/usr/share/elasticsearch/data` where all *Elasticsearch* data will be persisted.

Note: This kind of persistence won't work on windows.

We  are not going to need any local testing so all unnecessary port maps between the local system and the containers have been removed.

The files needed are now:

```├── conf
.
├── conf
│   ├── kibana
│   │   └── kibana.yml
│   └── logstash
│       └── gelf.com
├── docker-compose.yaml
└── logs
```

Our docker-compose is:

```yaml
version: '3.7'
services: 
    elasticsearch:
        image: elasticsearch:7.6.1
        container_name: elasticsearch
        networks: 
            - elk_net
        volumes:
            # Volume for logs persistence
            - type: bind
              source: ./logs
              target: /usr/share/elasticsearch/data
        environment: 
            - discovery.type=single-node
    logstash:
        image: docker.elastic.co/logstash/logstash:7.6.1
        container_name: logstash
        networks: 
            - elk_net
        volumes: 
            - ./conf/logstash:/usr/share/logstash/pipeline
        depends_on: 
            -  elasticsearch
    kibana:
        image: docker.elastic.co/kibana/kibana:7.6.1
        container_name: kibana
        ports: 
            # Kibana interface
            - 5601:5601
        networks: 
            - elk_net
        volumes: 
            - ./conf/kibana:/usr/share/kibana/config/
        depends_on: 
            - logstash
    log-to-elk:
        # This is a simple microservice that sends
        # data to logstash when it receives a GET request.
        image: rpardom/log-to-elk-microservice
        container_name: log-to-elk
        ports: 
            # To receive the curls for logs generation
            - 8080:8080
        networks: 
            - elk_net

networks: 
    elk_net:
        driver: bridge

```

The results are a bit surprising I thought we would need to also persist *Kibana's* data but it [seems](https://discuss.elastic.co/t/kibana-keep-state-dashboards-visualizations-settings-on-docker-elk/94302) it is also saved in `/usr/share/elasticsearch/data` inside the logstash container.

It might be interesting to investigate other more advanced persistance methods. Such as the new [snapshot functionality](http://chrissimpson.co.uk/elasticsearch-snapshot-restore-api.html). This would be much better in a production environment.

### Testing

1. Go into the *Kibana* app at http://localhost:5601.

2. Go to discover (second option of left toolbar) 

3. Create a index pattern called: `logstash*`

4. In the next screen choose `@timestap`

5. Once you are done, send a request to the microservice with:

   ```bash
   curl localhost:8080/hello
   ```

6. Reload the page and you will see the log of `INFO` level sent by your microservice.

7. You should've seen some data in your `/logs` directory by now :stuck_out_tongue_winking_eye:

8. Shut down everything with:

   ```bash
   docker-compose down
   ```

9. Start everything again with:

   ```bash
   docker-compose up -d
   ```

10. You should be able to see your past log entries in the discover tab, persistence is working.

## Clean up

Don't leave without cleaning your machine!

```bash
docker-compose down --volumes --rmi all --remove-orphans
```


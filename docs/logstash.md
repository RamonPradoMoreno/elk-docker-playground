# Logstash

## What is it?

It is a **data collection** engine. it is really fast and allows for ETLs The data can be **e**xtracted from a web **t**ransformed as it enters and **l**oaded in some destination, for example, a database.

## Why use it?

1. Horizontally scalable data processing pipeline with strong Elasticsearch and Kibana synergy.
2. It has many plugins you can practically ingest data from anywhere.
3. The data collected can also be redirected almost [anywhere](https://www.elastic.co/guide/en/logstash/7.x/introduction.html#_choose_your_stash).

## How does it work?

Logstash processes events in three different stages that are known as *the pipeline*:

1. Input: Something enters the logstash node. Examples:
   * **file**: reads from a file on the filesystem, much like the UNIX command `tail -0F`
   * **syslog**: listens on the well-known port 514 for syslog messages and parses according to the RFC3164 format
   * **redis**: reads from a redis server.
   * **beats**: processes events sent by [Beats](https://www.elastic.co/downloads/beats).
   * [More inputs](https://www.elastic.co/guide/en/logstash/7.x/input-plugins.html)
2. Filter: The event is processed. Examples:
   * **grok**: parse and structure arbitrary text.
   * **mutate**: rename, remove, replace, and modify fields in your events.
   * **drop**: drop an event completely, for example, *debug* events.
   * **geoip**: add information about geographical location of IP addresses (also displays amazing charts in Kibana!)
   * [More filters](https://www.elastic.co/guide/en/logstash/7.x/filter-plugins.html)
3. Output: The event is sent somewhere. An event might be sent to multiple places. Examples:
   * **elasticsearch**: send event data to Elasticsearch. If you’re planning to save your data in an efficient, convenient, and easily queryable format…Elasticsearch is the way to go.
   * **file**: write event data to a file on disk.
   * **graphite**: send event data to [graphite](http://graphite.readthedocs.io/en/latest/), a popular open source tool for storing and graphing metrics. 
   * **statsd**: send event data to statsd, a service that "listens for statistics, like counters and timers, sent over UDP and sends aggregates to one or more pluggable backend services". If you’re already using statsd, this could be useful for you!
   * [More outputs](https://www.elastic.co/guide/en/logstash/7.x/output-plugins.html)

## How do I configure it?

To configure Logstash, you create a config file that specifies which plugins you want to use and settings for each plugin.

Here is our current example:

```json
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

## Wanna go deeper?

1. [The bible](https://www.elastic.co/guide/en/logstash/7.x/index.html)
2. [Introduction](https://www.elastic.co/guide/en/logstash/7.x/introduction.html#_choose_your_stash)
3. [How it works](https://www.elastic.co/guide/en/logstash/7.x/pipeline.html)
4. [Configuration](https://www.elastic.co/guide/en/logstash/7.x/configuration.html)


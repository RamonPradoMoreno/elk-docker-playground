# Logstash

## What is it?

***Explore and visualize your data and manage all things Elastic Stack.\***

Whether you’re a user or admin, Kibana makes your data actionable by providing three key functions. Kibana is:

- **An open-source analytics and visualization platform.** Use Kibana to explore your Elasticsearch data, and then build beautiful visualizations and dashboards.
- **A UI for managing the Elastic Stack.** Manage your security settings, assign user roles, take snapshots, roll up your data, and more — all from the convenience of a Kibana UI.
- **A centralized hub for Elastic’s solutions.** From log analytics to document discovery to SIEM, Kibana is the portal for accessing these and other capabilities.

## Why use it?

1. *Explore & query*: With [Discover](https://www.elastic.co/guide/en/kibana/7.x/discover.html), you can explore your data and search for hidden insights and relationships.
2. *Visualize & analyze*:  Use [Lens](https://www.elastic.co/guide/en/kibana/7.x/lens.html), our drag-and-drop interface, to rapidly build charts, tables, metrics, and more. If there is a better visualization for your data, **Lens** suggests it, allowing for quick switching between visualization types. Once your visualizations are just the way you want, use [Dashboard](https://www.elastic.co/guide/en/kibana/7.x/dashboard.html) to collect them in one place.
3. *Organize & secure*: Want to share Kibana’s goodness with other people or teams? You can do so with [Spaces](https://www.elastic.co/guide/en/kibana/7.x/xpack-spaces.html), built for organizing your visualizations, dashboards, and indices. Think of a space as its own mini Kibana installation — it’s isolated from all other spaces, so you can tailor it to your specific needs without impacting others. You can take this all one step further with Kibana’s security features, and control which users have access to each space. Kibana allows for fine-grained controls, so you can give a user read-only access to dashboards in one space, but full access to all of Kibana’s features in another.
4. *Management*: [Management](https://www.elastic.co/guide/en/kibana/7.x/management.html) provides guided processes for managing all things Elastic Stack — indices, clusters, licenses, UI settings, index patterns, and more. Want to update your Elasticsearch indices? Set user roles and privileges? Turn on dark mode? Kibana has UIs for all that.
5. *Detect*: As a hub for Elastic’s [solutions](https://www.elastic.co/products/), Kibana can help you find security vulnerabilities, monitor performance, and address your business needs. Get alerted if a key metric spikes. Detect anomalous behavior or forecast future spikes. Root out bottlenecks in your application code. Kibana doesn’t limit or dictate how you explore your data.

## How does it work?

No need to know.

## How do I configure it?

The Kibana server reads properties from the `kibana.yml` file on startup. We provide that file from our `/config` directory. You can see a list of all possible configurations and what they mean [here](https://www.elastic.co/guide/en/kibana/7.x/settings.html).

## Wanna go deeper?

1. [The bible](https://www.elastic.co/guide/en/kibana/7.x/index.html)


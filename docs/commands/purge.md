---
id: purge
title: Purge
---
The purge command deletes cached Docker images, Helm charts or downloaded Blueprints from Shipyard.

## Command Usage
```shell
Purges Docker images, Helm charts, and Blueprints downloaded by Shipyard

Usage:
  shipyard purge [flags]

Examples:

  shipyard purge
	

Flags:
  -h, --help   help for purge
```

## Example
```shell
➜ shipyard purge
2020-04-21T14:00:17.962+0100 [INFO]  Removing image: image=docker.io/nicholasjackson/fake-service:v0.9.0
2020-04-21T14:00:17.972+0100 [INFO]  Removing image: image=docker.io/envoyproxy/envoy:v1.14.1
2020-04-21T14:00:17.976+0100 [INFO]  Removing Helm charts: path=/home/nicj/.shipyard/helm_charts
2020-04-21T14:00:17.976+0100 [INFO]  Removing Blueprints: path=/home/nicj/.shipyard/helm_charts
```

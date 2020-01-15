---
id: install
title: Installing Shipyard
---

## Prerequisites

Shipyard runs on MacOS, Linux and Windows (with WSL), all applications run in Docker containers. To use Shipyard you need a recent version of Docker.

[Docker](https://docs.docker.com/)

To install shipyard either use the quick install script:

```shell
curl https://shipyard.run/install | bash
```

or download the appropriate release from GitHub

[https://github.com/shipyard-run/shipyard/releases](https://github.com/shipyard-run/shipyard/releases)

## Running your first blueprint

Blueprints are packages of Shipyard configuration which allow you to run cloud native applications on your computer with Docker

You can find an example blueprint at the following location:

[https://github.com/shipyard-run/blueprints/tree/master/vault-k8s](https://github.com/shipyard-run/blueprints/tree/master/vault-k8s)

Blueprints can either be run from the local filesystem

```shell
git clone https://github.com/shipyard-run/blueprints.git
cd blueprints
yard2 run ./vault-k8s
```

or directly from the GitHub repository

```shell
yard2 run github.com/shipyard-run/blueprints//vault-k8s
```

## Stoping a blueprint

To stop a blueprint use the `yard2 delete` command

```shell
➜ yard2 delete 
Shipyard version: v0.0.0.alpha.9

Deleting 9 resources

2020-01-15T16:31:19.775Z [INFO]  Destroy Documentation: ref=docs
2020-01-15T16:31:19.775Z [INFO]  Destroy Container: parent_ref=docs ref=docs
2020-01-15T16:31:20.178Z [INFO]  Destroy Container: parent_ref=docs ref=terminal
2020-01-15T16:31:20.672Z [INFO]  Destroy Ingress: ref=k8s-dashboard
2020-01-15T16:31:20.672Z [INFO]  Destroy Container: parent_ref=k8s-dashboard ref=k8s-dashboard
2020-01-15T16:31:21.145Z [INFO]  Destroy Ingress: ref=vault-http
2020-01-15T16:31:21.145Z [INFO]  Destroy Container: parent_ref=vault-http ref=vault-http
2020-01-15T16:31:21.572Z [INFO]  Destroy Kubernetes configuration: ref=dashboard config=[/home/nicj/.shipyard/state/stack/k8s_config]
2020-01-15T16:31:22.396Z [INFO]  Destroy Helm chart: ref=vault
2020-01-15T16:31:22.396Z [INFO]  Destroy Cluster: ref=k3s
2020-01-15T16:31:22.396Z [INFO]  Destroy Container: parent_ref=k3s ref=server.k3s
2020-01-15T16:31:23.220Z [DEBUG] Deleting Volume: ref=k3s name=k3s.volume
2020-01-15T16:31:23.228Z [INFO]  Destroy Container: ref=tools
2020-01-15T16:31:23.748Z [INFO]  Destroy Network: ref=cloud
2020-01-15T16:31:23.862Z [INFO]  Destroy Network: ref=wan
```
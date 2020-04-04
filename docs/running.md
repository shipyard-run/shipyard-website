---
id: running
title: Running your first blueprint
---

## Running your first blueprint

Blueprints are packages of Shipyard configuration which allow you to run cloud native applications on your computer. They can
be run by downloading them to your machine or by running them direct from Git repos.

You can find an example blueprints at the following location:

[https://github.com/shipyard-run/blueprints](https://github.com/shipyard-run/blueprints)


## Running blueprints from the local filesystem

To run a blueprint from your local machine first clone the example blueprints repo:

```shell
git clone https://github.com/shipyard-run/blueprints.git
cd blueprints
```

You can then run a blueprint and create the resources using the `shipyard run` command with the path of
the blueprint you would like to run. The following example runs a blueprint which runs HashiCorp Vault on
Kubernetes. When you run the following command Shipyard pulls and starts any necessary Docker containers,
then opens the browser windows defined by the blueprint.

```shell
shipyard run ./vault-k8s
Running configuration from:  ./vault-k8s

2020-04-04T17:15:28.988+0100 [DEBUG] Statefile does not exist
2020-04-04T17:15:28.989+0100 [INFO]  Creating Network: ref=cloud
2020-04-04T17:15:44.012+0100 [INFO]  Creating Container: ref=tools
2020-04-04T17:15:44.012+0100 [INFO]  Creating Cluster: ref=k3s
2020-04-04T17:15:44.012+0100 [INFO]  Creating Documentation: ref=docs
#...
########################################################

Title HashiCorp Vault and Kubernetes
Author Nic Jackson

########################################################


This blueprint creates a Kubernetes cluster with Vault Helm chart installed

0.1 Environment Variables
```

## Running blueprints from Git repositories

Blueprints can also be run directly from the Git repositories, the following command will download the blueprint
from github and then start any resources defined inside it. Blueprints are downloaded to your `$HOME/.shipyard/blueprints` folder
with the the full repository path.

```shell
shipyard run github.com/shipyard-run/blueprints//vault-k8s
```

## Stoping a blueprint

To stop a blueprint use the `shipyard destroy` command

```shell
➜ shipyard destroy
2020-04-04T17:21:27.340+0100 [INFO]  Destroy Ingress: ref=vault-http
2020-04-04T17:21:27.340+0100 [INFO]  Destroy Container: ref=tools
2020-04-04T17:21:27.340+0100 [INFO]  Destroy Kubernetes configuration: ref=dashboard config=[/home/nicj/go/src/github.co
m/shipyard-run/blueprints/vault-k8s/k8s_config]
2020-04-04T17:21:27.340+0100 [INFO]  Destroy Ingress: ref=k8s-dashboard
2020-04-04T17:21:27.340+0100 [INFO]  Destroy Helm chart: ref=vault
2020-04-04T17:21:27.340+0100 [INFO]  Destroy Documentation: ref=docs
```

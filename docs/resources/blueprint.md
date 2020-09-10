---
id: blueprint
title: Blueprint
---

The blueprint resource is a special type of resource which allows you to specify certain global parameters for Shipyard, and information which is output when someone runs the blueprint. Blueprint READMEs help the users of your blueprint get started, any information such as the URIs for created resources
should be included as should any passwords or other information needed to interact with the resources.

## Minimal example

~~~markdown
---
title: Simple Kubernetes Example
author: Nic Jackson
slug: k8s_cluster
env:
  - KUBECONFIG=${HOME}/.shipyard/config/k3s/kubeconfig.yaml
browser_windows: http://consul-http.ingress.shipyard.run:8500,https://www.google.com
shipyard_version: ">= 0.1.1"
---

# Simple Kubernetes Cluster

This blueprint shows how you can create a simple Kubernetes cluster

Blueprint READMEs are written in markdown and honor most of the markdown formatting rules for example:

```
# Headings

A description of this section

## Headings 2
```

### Code blocks

```go
func main() {
  blah
}
```

~~~

When the user runs the blueprint this file will be output to their terminal once the `run` command completes

```shell
2020-08-15T07:52:13.692+0100 [INFO]  Applying Kubernetes configuration: ref=k3s config=[/shipyard-run/shipyard/example/out.yaml]
2020-08-15T07:52:13.692+0100 [INFO]  Creating Ingress: ref=app

########################################################

Title Example App -  Kubernetes
Author Nic Jackson

Simple Kubernetes

This blueprint defines 1 output variables.

You can set output variables as environment variables for your current terminal session using the following command:

eval $(shipyard env)

To list output variables use the command:

shipyard output
```

## Parameters

### title

**Type: string**  
**Required: true**

Set a title for your blueprint

### author

**Type: string**  
**Required: true**

Set the author for your blueprint

### slug

**Type: string**  
**Required: false**

Set the slug for your blueprint

### env

**Type: []string**  
**Required: false**

Define environment variables which are required when interacting with your blueprint. Due to restrictions on the way that Unix systems handle shell sessions and environment variables it is not possible to automatically set envrionment variables as part of a `shipyard run`. Instead; environment varaibles which are defined in an env block are output in the OS specific format so that they can be set using a separate command, e.g.

```shell
eval $(shipyard env)
```

### shipyard_version

**Type: string**  
**Required: false**

[Semantic version](https://godoc.org/golang.org/x/mod/semver) string relating to the version of Shipyard which this blueprint is compatable with.

From version `0.1.0` Shipyard has the capability to automatically install and run other versions of Shipyard to allow compatibility between the version of Shipyard a blueprint was design for and the verison installed. If the user does not have a compatible version of shipyard installed they will be prompted to download and install the correct version. The original version of Shipyard is not overwritten, additional versions are stored in `$HOME/.shipyard/releases`.

```shell
➜ shipyard run .  
Running configuration from:  ./

Would you like to install version: v0.1.1 [y/n]: y
Running blueprint with version: v0.1.1
Running configuration from:  /home/nicj/go/src/github.com/shipyard-run/examples/single-container

2020-08-15T08:34:00.182+0100 [INFO]  Creating Network: ref=local
...
```

### browser_windows

**Type: string**  
**Required: false**

`browser_windows` is a comma separated string of URLs to open in the browser once a run completes. This parameter can be used in addition to the `open_in_browser` resource parameter to open URLs not defined by a resource.

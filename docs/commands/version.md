---
id: version
title: Version
---

The `version` command allows you to manage the currently installed versions of Shipyard.

```shell
➜ shipyard version
Current Version: 0.1.2

Usage:
  shipyard version [flags]
  shipyard version [command]

Available Commands:
  install     Install a Shipyard version
  list        List the available Shipyard versions

Flags:
  -h, --help   help for version

Use "shipyard version [command] --help" for more information about a command.
```

To allow compatability between the version of Shipyard a user has installed and the version ed to create resources, Shipyard allows you to create resources with versions other than the main installed version.

This capability is either executed automatically when a blueprint author specifies the `shipyard_version` in the blueprint ReadMe.

```
---
title: Simple Kubernetes Example
author: Nic Jackson
slug: k8s_cluster
env:
  - KUBECONFIG=${HOME}/.shipyard/config/k3s/kubeconfig.yaml
browser_windows: http://consul-http.ingress.shipyard.run:8500,https://www.google.com
shipyard_version: ">= 0.1.1"
---
```

Or when a you run a blueprint with the `-v` flag:

```
➜ shipyard run -v 0.1.2 .
Running blueprint with version: v0.1.2
Running configuration from:  /home/nicj/go/src/github.com/shipyard-run/shipyard/examples
```
---
id: destroy
title: Destroy
---

The destroy command, removes the currently defined resources.

## Command Usage

```
Destroy the current stack or file. 
        If the optional parameter "file" is passed then only the resources contained
        in the file will be destroyed

Usage:
  shipyard destroy [file] [flags]

Examples:
yard destroy

Flags:
  -h, --help   help for destroy
```

## Example

```shell
➜ shipyard destroy
2020-08-16T13:33:31.160+0100 [INFO]  Destroy Kubernetes configuration: ref=app config=[/home/nicj/go/src/github.com/shipyard-run/shipyard-website/examples/simple_kubernetes/k8s_app]
2020-08-16T13:33:31.160+0100 [INFO]  Destroy Ingress: ref=app type=ingress
2020-08-16T13:33:31.394+0100 [INFO]  Destroy Cluster: ref=k3s
2020-08-16T13:33:31.832+0100 [INFO]  Destroy Network: ref=local
```
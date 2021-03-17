---
id: nomad_cluster
title: Nomad Cluster
---

The resource type `nomad_cluster` allows you to create Nomad clusters.

## Image Caching

To save bandwidth all images launched from either the Nomad server or the clients are cached by Shipyard. Currently images
from the following registries are cached:

* k8s.gcr.io 
* gcr.io 
* asia.gcr.io 
* eu.gcr.io 
* us.gcr.io 
* quay.io
* ghcr.io"
* docker.io

To clear the cache, you can use the [purge](/docs/commands/purge) command.

## Minimal Example

```javascript
nomad_cluster "dev" {
  network {
    name = "local"
  }
}

network {
  name = "local"
}
```

```
shipyard run github.com/shipyard-run/shipyard-website/examples/nomad_cluster//minimal
```

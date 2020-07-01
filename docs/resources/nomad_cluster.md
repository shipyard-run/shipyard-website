---
id: nomad_cluster
title: Nomad Cluster
---

The resource type `nomad_cluster` allows you to create Nomad clusters.

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

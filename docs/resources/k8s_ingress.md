---
id: k8s_ingress
title: Kubernetes Ingress
---

The `k8s_ingress` resource allows resources running in a `k8s_cluster` to be exposed to the network or local host.

Full Documentation Coming Soon.

## Minimal example

```javascript
k8s_ingress "vault-http" {
  cluster = "k8s_cluster.k3s"
  service  = "vault"

  network {
    name = "network.cloud"
  }

  port {
    local  = 8200
    remote = 8200
    host   = 18200
  }
}
```

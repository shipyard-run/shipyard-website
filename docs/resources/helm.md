---
id: helm
title: Helm
---

The `helm` resource allows Helm charts to be provisioned to `k8s_cluster` resources.

Full Documentation Coming Soon.

## Minimal example

```javascript
helm "vault" {
  cluster = "k8s_cluster.k3s"
  chart = "github.com/hashicorp/vault-helm"

  values_string = {
    "server.dataStorage.size" = "128Mb"
  }
}
```

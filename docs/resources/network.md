---
id: network
title: Network
---

Network resources allow you to create isolated networks for your resources. There is no limit to the number of Network resources you can create, the only limitation is that they must not have overlapping subnets. 

## Simple Example

```javascript
network "local" {
  subnet = "10.10.0.0/16"
}

k8s_cluster "k3s" {
  driver  = "k3s"
  version = "v1.17.4-k3s1"

  network {
    name = "network.local"
  }
}
```

## Parameters

### subnet
**Type: `string`**  
**Required: true**

Subnet to use for the network, must not overlap any other existing networks.
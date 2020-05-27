---
id: helm
title: Helm
---

The `helm` resource allows Helm charts to be provisioned to `k8s_cluster` resources.

## Minimal example

### Install Helm from a remote GitHub repository

```javascript
helm "vault" {
  cluster = "k8s_cluster.k3s"
  chart = "github.com/hashicorp/vault-helm"

  values_string = {
    "server.dataStorage.size" = "128Mb"
  }
}
```

### Install Helm from a local folder

```javascript
helm "vault" {
  cluster = "k8s_cluster.k3s"
  chart = "./files/helm/vault"

  values_string = {
    "server.dataStorage.size" = "128Mb"
  }
}
```

## Parameters

### depends_on 
**Type: `[]string`**  
**Required: false**

Depends on allows you to specify resources which should be created before this one. In the instance of a destruction, this container will be destroyed before
resources in.

### cluster
**Type: `string`**  
**Required: true**

The Kubernetes cluster where the target application is running.

### values
**Type: `string`**  
**Required: false**

File path resolving to a YAML file containg values for the Helm chart.

### values_string
**Type: `map[string]string`**  
**Required: false**

Map of keys and values to set for the Helm chart. Heirachy in the Helm YAML for keys is replaced by chaining properties with a `.`


For example, given the following YAML values:
```yaml
server:
  nodes: 1

client:
  child:
    property: "a string"
```

The following values_string map could be used

```javascript
values_string = {
  "server.nodes" = 1
  "client.child.property" = "a string
}
```

### namespace
**Type: `string`**  
**Required: false**
**Default: "default"**

Kubernetes namespace to install the chart to.

### health_check
**Type: [HealthCheck](HealthCheck)**  
**Required: true**

Define a health check for the `k8s_config`, the resource will only be marked as succesfully created when the health check passes. Health checks operate on the runing state of containers based on the pod selector.

```javascript
health_check {
  timeout = "120s"
  pods = ["app.kubernetes.io/name=vault"]
} 
```


## Type `health_check`

A health_check stanza allows the definition of a health check which must pass before the `k8s_config` is marked as successfully created.

### timeout
**Type: `duration`**  
**Required: true**

The maximum duration to wait before marking the health check as failed. Expressed as a Go duration, e.g. `1s` = 1 second, `100ms` = 100 milliseconds.

### pods
**Type: `[]string`**  
**Required: true**

Pod selector to use for checks, a Pod is marked as healthy when all containers in all pods returned by the selector string are marked as running.
## health_check
**Type: `string`**  
**Required: false**
**Default: "default"**
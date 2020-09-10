---
id: k8s_config
title: Kubernetes Config
---

The `k8s_config` resource allows Kubernetes configuraton to be applied on a `k8s_cluster`. You can specify a list of paths or individual files and health checks for the resources.  A `k8s_config` only completes once the configuration has bene successfully applied and any health checks have passed. This allows you to create complex dependencies for your applications.


## Minimal example

```javascript
k8s_config "app" {
  depends_on = ["helm.consul"]

  cluster = "k8s_cluster.k3s"
  paths = [
    "./k8s_config/app",
    "./k8s_config/dashboard",
  ]

  wait_until_ready = true
}
```

## Parameters

### depends_on 
**Type: []string**  
**Required: false**

Depends on allows you to specify resources which should be created before this one. In the instance of a destruction, this container will be destroyed before
resources in.

### cluster
**Type: `string`**  
**Required: true**

Reference to a `k8s_clsuter` resource where the configuration will be applied, must be specified using the convention `k8s_cluster.<resource name>`.

### paths
**Type: `[]string`**  
**Required: true**

List of files or folders containing valid Kubernetes config.

### wait_until_ready
**Type: `bool`**  
**Required: true**

If `true` the `k8s_config` blocks until all resources in the specified `paths` progress to the `ready` state. Ready as a state is defined by Kubernetes and varies from resource to resource. For many kinds, ready is true when the resource has been successfully added or modified on the cluster.

### health_check
**Type: [HealthCheck](#type-health_check)**  
**Required: true**

Define a health check for the `k8s_config`, the resource will only be marked as succesfully created when the health check passes. Health checks operate on the runing state of containers based on the pod selector.

```javascript
health_check {
  timeout = "120s"
  pods    = ["app.kubernetes.io/name=vault"]
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

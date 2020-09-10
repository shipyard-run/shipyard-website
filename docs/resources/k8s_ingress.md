---
id: k8s_ingress
title: Kubernetes Ingress
---

The `k8s_ingress` resource allows resources running in a `k8s_cluster` to be exposed to the network or local host. Applications running as Kubernetes Deployments, Services, and Pods can be access from other resources or locally using port forwarding.

## Minimal example

```javascript
k8s_ingress "vault-http" {
  cluster  = "k8s_cluster.k3s"
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

## Parameters

### depends_on 
**Type: `[]string`**  
**Required: false**

Depends on allows you to specify resources which should be created before this one. In the instance of a destruction, this container will be destroyed before
resources in.

### network
**Type: `network_attachment`**  
**Required: true**

Network attaches the container to an existing network defined in a separate stanza. This block can be specified multiple times to attach the container
to multiple networks.

## cluster
**Type: `string`**  
**Required: true**

The Kubernetes cluster where the target application is running.

## service
**Type: `string`**  
**Required: false**

The Kubernetes service to expose. 

One of `service`, `deployment`, or `pod` must be specified.

## deployment
**Type: `string`**  
**Required: false**

The Kubernetes deployment to expose. 

One of `service`, `deployment`, or `pod` must be specified.

## pod
**Type: `string`**  
**Required: false**

The Kubernetes pod to expose. 

One of `service`, `deployment`, or `pod` must be specified.

## namespace
**Type: `string`**  
**Required: false**
**Default: "default"**

The Kubernetes namespace where the application is running. 

### port
**Type: [`port`](#type-port)**  
**Required: false**

A port stanza allows you to expose container ports on the host. This stanza can be specified multiple times.

```javascript
port {
  local = 80
  host = 8080
}
```

## Type `port`

A port stanza defines host to container communications

### local
**Type: `string`**  
**Required: true**

The local port in the container.

### host
**Type: `string`**  
**Required: true**

The host port to map the local port to.

### protocol
**Type: `string "tcp", "udp"`**  
**Required: false**
**Default: "tcp"**

The protocol to use when exposing the port, can be "tcp", or "udp".

### open_in_browser
**Type: `string`**  
**Required: false**
**Default: "/"**

Should a browser window be automatically opened when this resource is created. Browser windows will open at the path specified by this property.

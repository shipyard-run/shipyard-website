---
id: ingress
title: Ingress
---

The `ingress` resource allows you to expose resources in Kubernetes clusters to your local 
machine. It also allows services on your local machine to be exposed to Kubernetes. This resource
will eventually replace all other ingress resources.

## Example: Expose a Kubernetes service to the local machine

The following example would expose the Kubernetes service `consul-server.default.svc` port `8500` to `localhost:8500`.

```javascript
ingress "consul-http" {
  source {
    driver = "local"
    
    config {
      port = 8500
    }
  }
  
  destination {
    driver = "k8s"
    
    config {
      cluster = "k8s_cluster.k3s"
      address = "consul-server.default.svc"
      port = 8500
    }
  }
}
```

## Example: Expose a local application as a Kubernetes service

The following example would expose the local application running at `localhost:9090` to applications running in 
Kubernetes. Shipyard automatically creates a service in the Kuberentes cluster with the same name
as the resource in the `shipyard` namespace. Applications in the cluster can use this address to send requests
to the local application. Using the following examlpe any request in Kubernetes sent to `local-app.shipyard.svc:9090`
would be proxied to `localhost:9090`. 

```javascript
ingress "local-app" {
  source {
    driver = "k8s"
    
    config {
      cluster = "k8s_cluster.k3s"
      port = 9090
    }
  }
  
  destination {
    driver = "local"
    
    config {
      address = "localhost"
      port = 9090
    }
  }
}
```

## Parameters

### depends_on 
**Type: `[]string`**  
**Required: false**

Depends on allows you to specify resources which should be created before this one. In the instance of a destruction, this container will be destroyed before
resources in.

### source
**Type: [Traffic](ingress#type-traffic)**  
**Required: true**

The source stanza allows the configuration for the source of the traffic.

```javascript
source {
  driver = "k8s"
  
  config {
    cluster = "k8s_cluster.k3s"
    port = 9090
  }
}
```

### destination
**Type: [Traffic](ingress#type-traffic)**  
**Required: true**

The destination stanza allows the configuration for the destination of the traffic.

```javascript
destination {
  driver = "local"
  
  config {
    address = "localhost"
    port = 9090
  }
}
```

## Type: `Traffic`

The traffic stanza is used by the `ingress` `source` and `destination` parmeters, it allows the configuration
of various parameters of the ingress.

### driver 
**Type: `string`**  
**Required: true**  
**Values: "local", "k8s", "docker"**  

`driver` allows you to specify the type of traffic `source` or `destination`, currently the following are valid values for the `driver` 
parameter.

* `local` - Traffic originates or terminates on the local host where shipyard is running. 
* `k8s` - Traffic originates or terminates on a Kubernetes cluster.
* `docker` - Traffic originates or terminates in a Docker conatainer.

### config 
**Type: [TrafficConfig](ingress#type-trafficconfig)**  
**Required: true**

The config stanza allows specific configuration for the different driver types. The parameters
specified inside the config block depend upon wheere it is used. See the [TrafficConfig](ingress#type-trafficconfig)
documentation for more information.

```javascript
config {
  address = "localhost"
  port = 9090
}
```


## Type: `TrafficConfig`

TrafficConfig allows you to specify configuation options such as the port for `Traffic` stanzas.

### cluster
**Type: `string`**  
**Required: if driver=='k8s' or driver=='nomad'**

Specify the cluster where the traffic will originate or terminate. This parameter is only needed when
the driver is either `k8s` or `nomad` clusters.

```javascript
config {
  cluster = "k8s_cluster.dev"
  port = 9090
}
```

### address
**Type: `string`**  
**Required: if destination**

The destination address for the traffic, can be any resolvable address or ip address.

Address only needs to be set when used inside a `destination` block.

### port
**Type: `string`**  
**Required: true**

The port for the source or desination traffic.

### open_in_browser
**Type: `string`**  
**Required: if source && driver=='local'**

`open_in_browser` allows you to specify the path of a url which will be automatically opened in a browser
window after the shipyard finishes creating resources.

The following example would open a browser window at the location `http://localhost:9090/ui`:

```javascript
source {
  driver = "local"

  config {
    port = 9090
    open_in_browser = "/ui"
  }
}
```

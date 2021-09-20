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

## Parameters

### depends_on
**Type: []string**  
**Required: false**

Depends on allows you to specify resources which should be created before this one. In the instance of a destruction, this container will be destroyed before
resources in.

### network
**Type: `network_attachment`**  
**Required: true**

Network attaches the container to an existing network defined in a separate stanza. This block can be specified multiple times to attach the container to multiple networks.

### version
**Type: `string`**  
**Required: false**

Nomad version to use, for a list of supported values please see the [docker hub tags](https://hub.docker.com/repository/docker/shipyardrun/nomad) below. If not specified the latest version of the driver will be used.

### client_nodes
**Type: `int`**  
**Required: false**
**Default: 0**

Number of client nodes to create for a cluster, a value of 0 creates a combined server and client.

### env
**Type: [key_value](container.md/#key_value)**  
**Required: false**

An env stanza allows you to set environment variables for nodes in the cluster. This stanza can be specified multiple times.

```javascript
env {
  key   = "PATH"
  value = "/usr/local/bin"
}
```

### image
**Type: [image](container.md/#type-image)**  
**Required: false**

The `image` block allows you to specify images which will be copied from the local cache to the remote cluster. Kubernetes clusters have their own local Docker image cache, if images are not preloaded to the local cache then Kubernetes will attempt to retrieve these from a remote repository when starting a container.

`image` can also be used to push local builds which are not stored in a remote container registry.

Can be specified multiple times.

### server_config
**Type: `string`**  
**Required: false**

Path to a file containing additional server configuration to add to the cluster. 

By default the server is created with the following config, stored at the filepath `/etc/nomad.d/config.hcl`.

```
data_dir = "/etc/nomad.d/data"

server {
  enabled = true
  bootstrap_expect = 1
}
```

Specifying this parameter will mount the file given to the server container at the path `/etc/nomad.d/server_user_config.hcl`.
When starting, Nomad merges all configuration files in the directory `/etc/nomad.d/`

For a full list of permissable configuration entries please see the [Nomad documentation](https://www.nomadproject.io/docs/configuration).

### client_config
**Type: `string`**  
**Required: false**

Path to a file containing additional client configuration to add to the cluster. By default client nodes are created with the following config, stored at the filepath `/etc/nomad.d/config.hcl`. In the instance that the `client_nodes` parameter is set to 0, the following client config is merged with the server config.

```
data_dir = "/etc/nomad.d/data"

client {
	enabled = true

	server_join {
		retry_join = ["%s"]
	}
}

plugin "raw_exec" {
  config {
	enabled = true
  }
}
```

Specifying this parameter will mount the file given to the server container at the path `/etc/nomad.d/client_user_config.hcl`.
When starting, Nomad merges all configuration files in the directory `/etc/nomad.d/`

For a full list of permissable configuration entries please see the [Nomad documentation](https://www.nomadproject.io/docs/configuration).

### consul_config
**Type: `string`**  
**Required: false**

By default, the Nomad server and clients nodes run `Consul Agent` as a daemon. This allows Nomad to register with Consul and perform service discovery.

The default configuration for Consul is stored at the filepath `/etc/consul.d/config/config.hcl` and contains the following:

```javascript
data_dir  = "/tmp/"
log_level = "DEBUG"

server = false

bind_addr      = "0.0.0.0"
client_addr    = "0.0.0.0"
advertise_addr = "{{GetInterfaceIP \"eth0\"}}"

ports {
  grpc = 8502
}

connect {
  enabled = true
}
```

This parameter is a location to a file containing additional Consul configuration that you would like to apply to the Nomad server and clients. 

For example, to configure the local Consul agent to join an external Consul cluster, you could use the following:

```javascript
template "nomad_config" {

  source = <<-EOS
  datacenter = "dc1"
  retry_join = ["consul.container.shipyard.run"]
  EOS

  destination = "${data("nomad-config")}/consul_config.hcl"
}

nomad_cluster "dev" {
  client_nodes = "${var.client_nodes}"

  network {
    name = "network.cloud"
  }

  consul_config = "${data("nomad-config")}/consul_config.hcl"
}
```

### volume
**Type: [volume](container.md/#type-volume)**  
**Required: false**

A volume allows you to specify a local volume which is mounted to the container when it is created. This stanza can be specified
multiple times. This can be used to mount custom configuration for custom clusters such as registry configuration for K3s [https://rancher.com/docs/k3s/latest/en/installation/private-registry/](https://rancher.com/docs/k3s/latest/en/installation/private-registry/).

```javascript
volume {
  source      = "./files/registries.yaml"
  destination = "/etc/rancher/k3s/registries.yaml"
}
```
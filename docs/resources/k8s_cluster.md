---
id: k8s_cluster
title: Kubernetes Cluster
---

The `k8s_cluster` resource allows the creation of Kubernetes clusters running in Docker.

## Minimal example

```javascript
k8s_cluster "k3s" {
  driver  = "k3s" // default
  version = "v1.17.4-k3s1"

  nodes = 1 // default

  network {
    name = "network.local"
  }
}

network "local" {
  subnet = "10.10.0.0/16"
}
```

### Run this example:

```
shipyard run github.com/shipyard-run/shipyard-website/examples/k8s_cluster//minimal
```

## Description

`k8s_cluster` resources run in an isolated Docker container using [Rancher's K3s](https://k3s.io/). On creation the `k8s_cluster` resource adds a Kubernetes Configuration file to your local computer to at the path `${HOME}/.shipyard/config/<cluster name>/kubeconfig.yaml`. This allows you to interact with the cluster using local tooling like `kubectl` and `helm`.

```
➜ kubectl get pods --all-namespaces
NAMESPACE     NAME                                      READY   STATUS    RESTARTS   AGE
kube-system   local-path-provisioner-58fb86bdfd-w6bg6   1/1     Running   0          111s
kube-system   metrics-server-6d684c7b5-86f86            1/1     Running   0          111s
kube-system   coredns-6c6bb68b64-m4nqj                  1/1     Running   0          111s
```

## Deploying applications

Besides using local tooling to deploy applications to your cluster you can use the Shipyard resources `helm` and `k8s_config`, these resources allow you to provision Helm charts and vanilla Kubernetes resource files.

### Deploying Helm charts

The following example shows a `helm` resource which would install a remote Helm chart for HashiCorp Vault.

Since Shipyard has a full understanding of the dependencies in your application the `helm` charts do not run until the cluster is fully up and running. Simply referencing the cluster in the `helm` chart stanza is the only thing required. Health checks can also be added to `helm` chart resources ensuring the next step of the dependency chain does not start before the applicaiton is running.

For more information on the `helm` resource type please see the documentation for that resource `/docs/resources/helm`.

```javascript
helm "vault" {
  cluster = "k8s_cluster.k3s"
  chart = "github.com/hashicorp/vault-helm"

  values_string = {
    "server.dataStorage.size" = "128Mb"
  }
}
```

### Deploying Kubernetes Resource files

The following example shows a `k8s_config` resource which would apply the Kubernetes resources defined in the referenced pahts to the Kubernetes cluster.

The `k8s_config` resource is only applied once the referenced cluster is running and healthy, in addition it is possible to specify optional dependencies. In this case there is an optional dependency on the successful application of a `helm` resource.

For more information on the `k8s_config` resource type please see the documentation for that resource [/docs/resources/k8s_config](/docs/resources/k8s_config).

```javascript
k8s_config "app" {
  depends_on = ["helm.vault"]
  cluster = "k8s_cluster.k3s"

  paths = [
    "./k8s_config/app",
    "./k8s_config/dashboard",
    "./k8s_config/gloo-loop/crds.yml",
    "./k8s_config/gloo-loop/gloo.yml"
  ]

  wait_until_ready = true
}
```

## Exposing resources

Resources running in your Kubernetes cluster can be exposed using the [k8s_ingress](/docs/resources/k8s_ingress) resource type. The following example shows how a Kubernetes service `vault` port 8200 can be exposed to the local host at port 18200. For more information on the `k8s_ingress` resource please see the documentation [/docs/resouces/k8s_ingress](/docs/resources/k8s_ingress).

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


## Parameters

### depends_on
**Type: []string**  
**Required: false**

Depends on allows you to specify resources which should be created before this one. In the instance of a destruction, this container will be destroyed before
resources in.

### network
**Type: `network_attachment`**  
**Required: true**

Network attaches the container to an existing network defined in a separate stanza. This block can be specified multiple times to attach the container
to multiple networks.

### driver
**Type: `string "k3s"`**  
**Required: true**

The `k8s_cluster` resource can create Kubernetes clusters using different versions of Kubernetes, currently only Ranchers K3s is supported however support for Kind is also planned.

### version
**Type: `string`**  
**Required: false**

Version of the driver to use, for a list of supported values please see the [matrix](#supported-kubernetes-versions) below. If not specified the latest version of the driver will be used.

### nodes
**Type: `int`**  
**Required: false**

Number of client nodes to create for a cluster, a value of 1 creates a combined server and client. Currently only single node clusters are supported.

### image
**Type: [image](#type-image)**  
**Required: false**

The `image` block allows you to specifiy images which will be copied from the local cache to the remote cluster. Kubernetes clusters have their own local Docker image cache, if images are not preloaded to the local cache then Kubernetes will attempt to retrieve these from a remote repository when starting a container.

`image` can also be used to push local builds which are not stored in a remote container registry.

Can be specified multiple times.

### volume
**Type: [volume](container.md/#type-volume)**  
**Required: false**

A volume allows you to specify a local volume which is mounted to the container when it is created. This stanza can be specified
multiple times. This can be used to mount custom configuration for custom clusters such as registry configuration for K3s [https://rancher.com/docs/k3s/latest/en/installation/private-registry/](https://rancher.com/docs/k3s/latest/en/installation/private-registry/).

```javascript
volume {
  source = "./files/registries.yaml"
  destination = "/etc/rancher/k3s/registries.yaml"
}
```

### port
**Type: port**  
**Required: false**

A port stanza allows you to expose container ports on the local network or host. This stanza can be specified multiple times.

```javascript
port {
  local = 80
  host = 8080
}
```

### port_range
**Type: port_range**  
**Required: false**

A port_range stanza allows you to expose a range of container ports on the local network or host. This stanza can be specified multiple times.

The following example would create 11 ports from 80 to 90 (inclusive) and expose them to the host machine.

```javascript
port {
  range = "80-90"
  enable_host = true
}
```

## Type `image`

Image defines a Docker image used when creating this container. An Image can be stored in a public or a private repository.

### name
**Type: `string`**  
**Required: true**

Name of the image to use when creating the container, can either be the full canonical name or short name for Docker official images.
e.g. `consul:v1.6.1` or `docker.io/consul:v1.6.1`.

### username
**Type: `string`**  
**Required: false**

Username to use when connecting to a private image repository

### password
**Type: `string`**  
**Required: false**

Password to use when connecting to a private image repository, for both username and password interpolated environment variables can be used
in place of static values.

```javascript
image {
  name = "myregistry.io/myimage:latest"
  username = "${env("REGISTRY_USERNAME")}"
  password = "${env("REGISTRY_PASSWORD")}"
}
```

## Supported Kubernetes Versions

Driver | Version
------ | --------
k3s    | v1.17.4-k3s1
---
id: functions
title: Functions
---

Shipyard configuration files can use built in functions which are interpolated at runtime. For example the `k8s_config(<cluster_name>)` function could be used to return the file path location for the Kubernetes config file used to access a cluster.

```javascript
output "KUBECONFIG" {
  value = k8s_config("k3s")
}
```

Functions can be used whenever you use a string or integer inside your Shipyard configuration

### env
**Parameters: `name (string)`**

The env function can be used to interpolate a system set environment variable inside your configuration.

```javascript
container "consul" {
  image {
    name = env("CONSUL_VERSION")
  }
}
```

### k8s_config
**Parameters: `cluster_name (string)`**

The k8s_config function can be used to interpolate the path of the Kubernetes config for a `k8s_cluster` resource created by Shipyard.
This can be used to access Kuberentes from the host running Shipyard.

```javascript
output "KUBECONFIG" {
  value = k8s_config("k3s")
}
```

### k8s_config_docker
**Parameters: `cluster_name (string)`**

The k8s_config_docker function can be used to interpolate the path of the Kubernetes config for a `k8s_cluster` resource created by Shipyard. Unlike the
standard k8s_config function, this function returns a Kuberentes config file suitable for accessing the cluster from the Docker network.

```javascript
container "kubectl" {
  image   {
    name = "bitnami/kubectl"
  }

  command = ["kubectl", "get", "pods"]

  # Map K8s config for remote access to the default location
  volume {
    source      = "${k8s_config_docker("k3s")}"
    destination = "/.kube/config"
  }
}
```

### home

The home function returns the full path to the current users home folder.

```javascript
container "consul" {
  volume {
    source      = home()
    destination = "/home/nicj"
  }
}
```

### shipyard

The shipyard function returns the full path to the `.shipyard` folder inside your home folder.

```javascript
container "consul" {
  volume {
    source      = shipyard()
    destination = "/home/nicj/.shipyard"
  }
}
```

### data
**Parameters: `path (string)`**

The data function returns the full path to a temporary data folder which is automatically removed when running `shipyard destroy`. 

```javascript
container "consul" {
  volume {
    source      = data("/consul_data")
    destination = "/etc/consul/data"
  }
}
```

### file
**Parameters: `path (string)`**

The file function loads the contents of a file at the given path. Note: This file must exist before `shipyard run` is executed.

```javascript
container "consul" {
  image {
    name = file("./files/consul_version.txt")
  }
}
```

### file_path

The file_path function returns the absolute path of the current configuration file.

```javascript
container "consul" {
  volume {
    source      = file_path()
    destination = "/var/data/myfile.hcl"
  }
}
```

### file_dir

The file_dir function returns the absolute directory of the current configuration file.

```javascript
container "consul" {
  volume {
    source      = file_dir()
    destination = "/var/data/myfiles"
  }
}
```

### docker_ip

Returns the IP address of the Docker engine Shipyard is using. Normally this will be localhost but in the instance
that a remote Docker engine has been configured using the `DOCKER_HOST` environment variable this function
will return only the hostname section of this variable. For example, `DOCKER_HOST=tcp://myhost.com:2375` 
the function would return `myhost.com`.

```javascript
output "CONSUL_HTTP_ADDR" {
  value = "${docker_ip()}:8500"
}
```

### docker_host

Returns the value from the environment variable `DOCKER_HOST`.

```javascript
container "consul" {
  volume {
    source = docker_host()
    destination = "/var/run/docker.sock"
  }
}
```

### shipyard_ip

The shipyard_ip function returns a non loopback IPV4 address for the machine running 
the `shipyard` run command.

```javascript
container "tools" {
  env_vars = {
     host = shipyard_ip()
  }
}
```

### cluster_api

The `cluster_api` function returns the full address for the given clusters API, accessible from the local machine.

```javascript
output "NOMAD_HTTP_ADDR" {
  value = ${cluster_api("dev")}
}
```
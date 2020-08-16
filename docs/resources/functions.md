---
id: functions
title: Functions
---

Shipyard configuration files can use built in functions which are interpolated at runtime. For example the `k8s_config(<cluster_name>)` function could be used to return the file path location for the Kubernetes config file used to access a cluster.

```javascript
output "KUBECONFIG" {
  value = "${k8s_config("k3s")}"
}
```

Functions can be used whenever you use a string or integer inside your Shipyard configuration

### env
**Parameters: `name (string)`**

The env function can be used to interpolate a system set environment variable inside your configuration.

```javascript
container "consul" {
  image {
    name = "${env("CONSUL_VERSION")}"
  }
}
```

### k8s_config
**Parameters: `cluster_name (string)`**

The env function can be used to interpolate the path of the Kubernetes config for a `k8s_cluster` resource created by Shipyard.

```javascript
output "KUBECONFIG" {
  value = "${k8s_config("k3s")}"
}
```

### home

The home function returns the full path to the current users home folder.

```javascript
container "consul" {
  volume {
    source = "${home()}"
    destination = "/home/nicj"
  }
}
```

### shipyard

The shipyard function returns the full path to the `.shipyard` folder inside your home folder.

```javascript
container "consul" {
  volume {
    source = "${shipyard()}"
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
    source = "${data("/consul_data)}"
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
    name = "${file("./files/consul_version.txt")}"
  }
}
```
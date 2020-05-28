---
id: exec_remote
title: Remote Exec
---

The Remove Exec resource allows the execution of arbitary commands and scripts. Execution can either be in a stand
alone container or can target an existing and running container.

## Minimal Example

### Register a service in Consul using a standalone container

```javascript
# Full example can be found at /examples/exec_remote/exec_stand_alone

exec_remote "exec_standalone" {
  depends_on = ["container.consul"]

  image {
    name = "consul:1.7.2"
  }
  
  network {
    name = "network.local"
  }

  cmd = "consul"
  args = [
    "services",
    "register",
    "/config/redis.hcl"
  ]

  // Mount a volume containing the config
  volume {
    source = "./config"
    destination = "/config"
  }

  env {
    key = "CONSUL_HTTP_ADDR"
    value = "http://consul.container.shipyard.run:8500"
  }
}
```

**Run this example:**

```shell
➜ shipyard run github.com/shipyard-run/shipyard-website/examples/exec_remote/exec_stand_alone
Running configuration from:  examples/exec_remote/exec_container

2020-04-29T09:15:23.331+0100 [DEBUG] Statefile does not exist
2020-04-29T09:15:23.331+0100 [INFO]  Creating Network: ref=local
2020-04-29T09:15:38.364+0100 [INFO]  Creating Container: ref=consul
2020-04-29T09:15:38.463+0100 [DEBUG] Image exists in local cache: image=consul:1.7.2
2020-04-29T09:15:38.463+0100 [INFO]  Creating Container: ref=consul
2020-04-29T09:15:38.490+0100 [DEBUG] Attaching container to network: ref=consul network=network.local
2020-04-29T09:15:38.935+0100 [DEBUG] Performing health check for address: address=http://consul.container.shipyard.run:8500/v1/status/leader
2020-04-29T09:15:39.940+0100 [DEBUG] Health check complete: address=http://consul.container.shipyard.run:8500/v1/status/leader
2020-04-29T09:15:39.940+0100 [INFO]  Remote executing command: ref=exec_container command=consul args=[services, register, /config/redis.hcl] image=<nil>
2020-04-29T09:15:39.942+0100 [DEBUG] 
2020-04-29T09:15:40.188+0100 [DEBUG] Registered service: redis
```

### Register a service in Consul using an existing container

```javascript
# Full example can be found at /examples/exec_remote/exec_stand_alone

exec_remote "exec_container" {
  target = "container.consul"

  cmd = "consul"
  args = [
    "services",
    "register",
    "/config/redis.hcl"
  ]
}
```

**Run this example:**

```shell
➜ shipyard run github.com/shipyard-run/shipyard-website/examples/exec_remote/exec_container
Running configuration from:  ./examples/exec_remote/exec_container

2020-04-29T09:09:48.593+0100 [DEBUG] Statefile does not exist
2020-04-29T09:09:48.593+0100 [INFO]  Creating Network: ref=local
2020-04-29T09:10:03.625+0100 [INFO]  Creating Container: ref=consul
2020-04-29T09:10:03.725+0100 [DEBUG] Image exists in local cache: image=consul:1.7.2
2020-04-29T09:10:03.725+0100 [INFO]  Creating Container: ref=consul
2020-04-29T09:10:03.755+0100 [DEBUG] Attaching container to network: ref=consul network=network.local
2020-04-29T09:10:04.181+0100 [DEBUG] Performing health check for address: address=http://consul.container.shipyard.run:8500/v1/status/leader
2020-04-29T09:10:05.186+0100 [DEBUG] Health check complete: address=http://consul.container.shipyard.run:8500/v1/status/leader
2020-04-29T09:10:05.187+0100 [INFO]  Remote executing command: ref=exec_container command=consul args=[services, register, /config/redis.hcl] image=<nil>
2020-04-29T09:10:05.189+0100 [DEBUG] 
2020-04-29T09:10:05.435+0100 [DEBUG] Registered service: redis

```


## Parameters


### depends_on 
**Type: []string**  
**Required: false**

Depends on allows you to specify resources which should be created before this one. In the instance of a destruction, this container will be destroyed before
resources in.

### target 
**Type: string**  
**Required: false**

Target container to execute the command in.

One of `target` or `image` must be specified.

### network
**Type: `network_attachment`**  
**Required: false**

Attaches the container to an existing network defined by the `network` resource stanza. This block can be specified multiple times to attach the container to multiple networks.

This block is ignored when `target` is specficied.

### image
**Type: `image`**  
**Required: false**

Image defines a Docker image to use when creating the container.

`image` is a required property when `target` is not used, a new container is created using the defined image, used for execution of the command.

One of `image` or `target` must be specified.

### command
**Type: string**  
**Required: false**

Command allows you to specify a command to execute when starting a container.

### args
**Type: []string**  
**Required: false**

Arguments passed to the  command to execute when starting a container. For example, to execute a command which installs Shipyard the following command and arguments can be used.

```javascript
command = "curl"

args = [
    "https://shipyard.run/install",
    "|",
    "bash",
    "-s"
]
```

### working_directory
**Type: string**  
**Required: false**

Set the working directory where the command will be executed.

### environment
**Type: key_value**  
**Required: false**

An environment stanza allows you to set environment variables in the container. This stanza can be specified multiple times.

```javascript
environment {
  key = "PATH"
  value = "/usr/local/bin"
}
```

### volume
**Type: volume**  
**Required: false**

A volume allows you to specify a local volume which is mounted to the container when it is created. This stanza can be specified multiple times.

Volumes can NOT be attached when a `target` is specified as it is not possible to add volumes to running containers. Volumes can only be used when an `image` is defined.

```javascript
volume {
  source = "./"
  destination = "/files"
}
```
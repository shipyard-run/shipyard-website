---
id: container
title: Container
---

The `container` resource allows you to run Docker containers.

## Minimal Example

```javascript
container "unique_name" {
    network {
        name = "network.cloud"
    }

    image {
        name = "consul:1.6.1"
    }
}

network "cloud" {
    subnet = "10.0.0.0/16"
}
```

#### Run this example:

```shell
shipyard run github.com/shipyard-run/shipyard-website/examples/container//minimal
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

### image
**Type: `image`**  
**Required: true**

Image defines a Docker image to use when creating the container.

### command
**Type: []string**  
**Required: false**

Command allows you to specify a command to execute when starting a container. Command is specified as an array of strings, each part of the
command is a separate string. For example, to start a container and follow logs at /dev/null the following command could be used.

```
command = [
    "tail",
    "-f",
    "/dev/null"
]
```

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

A volume allows you to specify a local volume which is mounted to the container when it is created. This stanza can be specified
multiple times.

```javascript
volume {
  source = "./"
  destination = "/files"
}
```

### port
**Type: port**  
**Required: false**

A port stanza allows you to expose container ports on the host.

```javascript
port {
  local = 80
  host = 8080
}
```

### privileged
**Type: boolean**  
**Required: false**
**Default: false**

Should the container run in Docker privledged mode?

### health_check
**Type: health_check**  
**Required: false**

Define a health check for the container, the resource will only be marked as succesfully created when the health check passes.

```javascript
health_check {
  timeout = "30s"
  http = "http://localhost:8500/v1/status/leader"
}
```


## Type `network_attachment`

Network attachment defines a network to which the container is attached.

### name
**Type: `string`**  
**Required: true**

Name of the network to attach the container to, specified in reference format. e.g. to attach to a network called `cloud`

```javascript
network {
  name = "network.cloud"
}
```

### ip_Address
**Type: `string`**  
**Required: false**

Static IP address to assign container for the network, the ip address must be within range defined by the network subnet.
If this parameter is ommitted an IP address will be automatically assigned.


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


## Type `key_value`

A key_value type allows you to specify a key and and an associated value.

### key
**Type: `string`**  
**Required: false**

### value
**Type: `string`**  
**Required: false**


## Type `volume`

A volume type allows the specification of an attached volume.

### source
**Type: `string`**  
**Required: true**

The source volume to mount in the container, can be specified as a relative `./` or absolute path `/usr/local/bin`. Relative paths are relative to
the file declaring the container.

### destination
**Type: `string`**  
**Required: true**

The destination in the container to mount the volume to, must be an absolute path.

### type
**Type: `string "bind", "volume", "tmpfs"`**  
**Required: false**
**Default: "bind"**

The type of the mount, can be one of the following values:
* bind - bind the source path to the destination path in the container
* volume - source is a Docker volume
* tmpfs - create a temporary filesystem


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


## Type `health_check`

A health_check stanza allows the definition of a health check which must pass before the container is marked as successfully created.

### timeout
**Type: `duration`**  
**Required: true**

The maximum duration to wait before marking the health check as failed. Expressed as a Go duration, e.g. `1s` = 1 second, `100ms` = 100 milliseconds.

### http
**Type: `string`**  
**Required: true**

The URL to check, health check expects a HTTP status code `200` to be returned by the URL in order to pass the health check. Status code will be user
configurable at a later date.

## Full Example

```javascript
container "unique_name" {
    depends_on = ["container.another"]

    network {
        name       = "network.cloud"
        ip_address = "10.0.0.200"
    }

    image {
        name     = "consul:1.6.1"
        username = "repo_username"
        password = "repo_password"
    }

    command = [
        "consul",
        "agent"
    ]

    env {
        key   = "CONSUL_HTTP_ADDR"
        value = "http://localhost:8500"
    }

    volume {
        source      = "./config"
        destination = "/config"
    }

    port {
        source = 8500
        remote = 8500
        host   = 18500
    }

    priviledged = false
}

network "cloud" {
    subnet = "10.0.0.0/16"
}
```
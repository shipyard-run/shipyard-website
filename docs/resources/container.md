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
**Type: `[]string`**  
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

### env
**Type: `key_value`**  
**Required: false**

An env stanza allows you to set environment variables in the container. This stanza can be specified multiple times.

```javascript
env {
  key   = "PATH"
  value = "/usr/local/bin"
}
```

Note the above format will be deprecated soon to use cleaner map based format.

```javascript
env {
  "key": "value"
}
```

### volume
**Type: `volume`**  
**Required: false**

A volume allows you to specify a local volume which is mounted to the container when it is created. This stanza can be specified
multiple times.

```javascript
volume {
  source      = "./"
  destination = "/files"
}
```

### port
**Type: `port`**  
**Required: false**

A port stanza allows you to expose container ports on the local network or host. This stanza can be specified multiple times.

```javascript
port {
  local = 80
  host  = 8080
}
```

### port_range
**Type: `port_range`**  
**Required: false**

A port_range stanza allows you to expose a range of container ports on the local network or host. This stanza can be specified multiple times.

The following example would create 11 ports from 80 to 90 (inclusive) and expose them to the host machine.

```javascript
port {
  range       = "80-90"
  enable_host = true
}
```

### privileged
**Type: `boolean`**  
**Required: false**  
**Default: false**

Should the container run in Docker privileged mode?

### health_check
**Type: `health_check`**  
**Required: false**

Define a health check for the container, the resource will only be marked as successfully created when the health check passes.

```javascript
health_check {
  timeout = "30s"
  http    = "http://localhost:8500/v1/status/leader"
}
```

### resources
**Type: `resources`**  
**Required: false**

Define resource constraints for the container

### max_restart_count
**Type: `integer`**  
**Required: false**  
**Default: 0**

The maximum number of times a container will be restarted when it exits with a status code other than 0

### run_as
**Type: `run_as`**  
**Required: false**  
**Default: container defaults**

Allows the container to be run as a specific user or group.

```javascript
run_as {
  user = "1000"
  group = "nicj"
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
If this parameter is omitted an IP address will be automatically assigned.

### aliases
**Type: `[]string`**  
**Required: false**

Aliases allow alternate names to specified for the container. Aliases can be used to reference a container across the network, the container
will respond to ping and other network resolution using the primary assigned name `[name].container.shipyard.run` and the aliases.

```javascript
network {
  name    = "network.cloud"
  aliases = ["alt1.container.shipyard.run", "alt2.container.shipyard.run"]
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
  username = env("REGISTRY_USERNAME")
  password = env("REGISTRY_PASSWORD")
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

### open_in_browser
**Type: `string`**  
**Required: false**  
**Default: "/"**

Should a browser window be automatically opened when this resource is created. Browser windows will open at the path specified by this property.

## Type `port_range`

A port_range stanza defines host to container communications by exposing a range of ports for the container.

### range
**Type: `string`**  
**Required: true**

The port range to expose, e.g, `8080-8082` would expose the ports `8080`, `8081`, `8082`.

### enable_host
**Type: `boolean`**  
**Required: false**  
**Default: false**

The host port to map the local port to.

### protocol
**Type: `string "tcp", "udp"`**  
**Required: false**  
**Default: "tcp"**

The protocol to use when exposing the port, can be "tcp", or "udp".

## Type `health_check`

A health_check stanza allows the definition of a health check which must pass before the container is marked as successfully created.

```javascript
health_check {
  duration = "60s"
  http = "http://myendpoint:9090/health"
  http_status_codes = [200,429] // optional
}
```

### timeout
**Type: `duration`**  
**Required: true**

The maximum duration to wait before marking the health check as failed. Expressed as a Go duration, e.g. `1s` = 1 second, `100ms` = 100 milliseconds.

### http
**Type: `string`**  
**Required: true**

The URL to check, health check expects a HTTP status code to be returned by the URL in order to pass the health check. HTTP status codes can be specified
by setting the `http_status_code` parameter. A default code of `200` is configured when `http_status_codes` is not set.

### http_status_codes
**Type: `[]int`**  
**Required: false**  
**Default: [200]**

HTTP status codes returned from the endpoint when called. If the returned status code matches any in the array then the health check will pass.

## Type `resources`

A resources type allows you to configure the maximum resources which can be consumed.

### cpu
**Type: `int`**  
**Required: false**

Set the maximum CPU which can be consumed by the container in MHz, 1 CPU == 1000MHz.

### cpu_pin
**Type: `[]int`**  
**Required: false**

Pin the container CPU consumption to one or more logical CPUs. For example to pin the container to the core 1 and 4.

```
resources {
  cpi_pin = [1,4]
}
```

### memory
**Type: `string`**  
**Required: false**

Maximum  memory which a container can consume, specified in Megabytes.

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
    
    port_range {
        range       = "9000-9002"
        enable_host = true
    }

    privileged = false
}

network "cloud" {
  subnet = "10.0.0.0/16"
}
```

## Type `run_as`

User and Group configuration to be used when running a container, by default Docker runs commands in the container as root id 0.

### user
**Type: `string`**  
**Required: false**

Linux user ID or user name to run the container as, this overrides the default user configured in the container image. 

### group
**Type: `string`**  
**Required: false**

Linux group ID or group name to run the container as, this overrides the default group configured in the container image.
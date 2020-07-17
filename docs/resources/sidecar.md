---
id: sidecar
title: Sidecar
---

The Sidecar resource allows you to run associated processes for Containers. Sidecar does not have its own network, a Sidecar resource
shares the network with the target container. For example, `localhost` in the `sidecar` is localhost` in the `container`.

Sidecar resources are not routable in the same way as container resources are. You can not map an ingress to a sidecar and a sidecar can
not expose ports. Traffic which is destined for a process running in a sidecar must be sent to the target container. The following example
highlights this capability.

## Minimal Example

```javascript
container "app" {
  image {
    name = "nicholasjackson/fake-service:v0.9.0"
  }

  env {
    key = "LISTEN_ADDR"
    value = "127.0.0.1:9090"
  }

  # The app does not directly expose port 80
  # Envoy in the sidecar is running on this Port
  # Sidecars can not directly create ports as they attach to the containers
  # network
  port {
    local = 80
    remote = 80
    host = 8080
  }
}

sidecar "envoy" {
  target = "container.app"
  
  image {
    name = "envoyproxy/envoy:v1.14.1"
  }

  command = ["envoy", "-c", "/config/envoy.yaml"]

  volume {
    source = "./envoyconfig.yaml"
    destination = "/config/envoy.yaml"
  }
}

network "cloud" {
    subnet = "10.0.0.0/16"
}
```

#### Run this example:

```shell
shipyard run github.com/shipyard-run/shipyard-website/examples/sidecar//minimal
```

Inspect the Service:

```shell
➜ curl localhost:8080
{
  "name": "Service",
  "uri": "/",
  "type": "HTTP",
  "ip_addresses": [
    "172.17.0.2"
  ],
  "start_time": "2020-04-21T12:44:55.259703",
  "end_time": "2020-04-21T12:44:55.259774",
  "duration": "71.7µs",
  "Headers": null,
  "body": "Hello World",
  "code": 200
}
```

## Parameters

### depends_on
**Type: []string**  
**Required: false**

Depends on allows you to specify resources which should be created before this one. In the instance of a destruction, this container will be destroyed before
resources in.

### target
**Type: string**  
**Required: true**

Target container to attach the sidecar to, e.g. `container.consul`.

### image
**Type: `image`**  
**Required: true**

Image defines a Docker image to use when creating the container.

### entrypoint
**Type: []string**  
**Required: false**

Entrypoint allows you to specify a command to execute when starting a container. Entrypoint is specified as an array of strings, each part of the
command is a separate string. For example, to start a container and follow logs at /dev/null the following command could be used.

```javascript
command = [
    "tail",
    "-f",
    "/dev/null"
]
```

Entrypoint can be used in addition with `command`, Docker containers often define an entrypoint which configures the base command to run, `command` is then used to specify additional parameters.

### command
**Type: []string**  
**Required: false**

Command allows you to specify a command to execute when starting a container. Command is specified as an array of strings, each part of the
command is a separate string. For example, to start a container and follow logs at /dev/null the following command could be used.

```javascript
command = [
    "tail",
    "-f",
    "/dev/null"
]
```

### env
**Type: key_value**  
**Required: false**

An env stanza allows you to set environment variables in the container. This stanza can be specified multiple times.

```javascript
env {
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

### privileged
**Type: boolean**  
**Required: false**
**Default: false**

Should the container run in Docker privileged mode?

### health_check
**Type: health_check**  
**Required: false**

Define a health check for the container, the resource will only be marked as successfully created when the health check passes.

```javascript
health_check {
  timeout = "30s"
  http = "http://localhost:8500/v1/status/leader"
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
container "app" {
  image {
    name = "nicholasjackson/fake-service:v0.9.0"
  }

  env {
    key = "LISTEN_ADDR"
    value = "127.0.0.1:9090"
  }

  # The app does not directly expose port 80
  # Envoy in the sidecar is running on this Port
  # Sidecars can not directly create ports as they attach to the containers
  # network
  port {
    local = 80
    remote = 80
    host = 8080
  }
}

sidecar "envoy" {
  depends_on = ["container.another"]
  target = "container.app"
  
  image {
    name = "envoyproxy/envoy:v1.14.1"
    username = "repo_username"
    password = "repo_password"
  }

  command = ["envoy", "-c", "/config/envoy.yaml"]

  volume {
    source = "./envoyconfig.yaml"
    destination = "/config/envoy.yaml"
  }

  env {
    key   = "CONSUL_HTTP_ADDR"
    value = "http://localhost:8500"
  }
    
  privileged = false
}

network "cloud" {
    subnet = "10.0.0.0/16"
}
```

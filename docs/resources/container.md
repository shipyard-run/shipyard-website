---
id: container
title: Container
---

Container allows you to run Docker containers

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
shipyard run github.com/shipyard-run/shipyard-website/exampes/container//minimal
```

## Parameters

### depends_on 
**Type: []string**  
**Required: false**

Depends on allows you to specify resources which should be created before this one. In the instance of a destruction, this container will be destroyed before
resources in.

### network
**Type: `network`**  
**Required: true**

Network attaches the container to an existing network defined in a separate stanza.

### image
**Type: `image`**  
**Required: true**

Image defines the Docker image to use when creating the container.

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
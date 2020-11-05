---
id: nomad_ingress
title: Nomad Ingress
---

The `nomad_ingress` resource allows tasks running in a `nomad_cluster` to be exposed to the network or local host. 

## Minimal example

Tasks in Nomad follow a heirachical strucutre `Job->[]Group->[]Task`, it is possible for a Job to contain more than one group
and for a group to contain more than one task. To expose a `Task` with a Nomad `Job`, you can define the name of the `job`, 
the `group` name, and the `task` name as individual parameters.

A Task may also expose a number of ports, which can be either defined by a number or a descriptive name, this can be 
specified in the `port` stanza.

It is possible that there may be multiple instances of a task running, in this instance the Shipyard ingress
will select an endpoint at random.

The following example shows how you would expose the `http` port for the `fake_service` task:

```javascript
nomad_ingress "fake-service-1" {
  cluster  = "nomad_cluster.dev"

  job = "example_1"
  group = "fake_service"
  task = "fake_service"

  port {
    local  = 19090
    remote = "http"
    host   = 19090
  }

  network  {
    name = "network.cloud"
  }
}

```

The corresponding Nomad Job file for this ingress looks like the following example:

```
job "example_1" {
  datacenters = ["dc1"]
  type = "service"
  
  group "fake_service" {
    count = 1

    network {
      port  "http" { 
        to = 19090
        static = 19090
      }
    }

    task "fake_service" {
      driver = "docker"
      
      logs {
        max_files     = 2
        max_file_size = 10
      }

      env {
        LISTEN_ADDR = ":19090"
        NAME = "Example1"
      }

      config {
        image = "nicholasjackson/fake-service:v0.18.1"

        ports = ["http"]
      }

      resources {
        cpu    = 500 # 500 MHz
        memory = 256 # 256MB

      }
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

### network
**Type: `network_attachment`**  
**Required: true**

Network attaches the container to an existing network defined in a separate stanza. This block can be specified multiple times to attach the container
to multiple networks.

## cluster
**Type: `string`**  
**Required: true**

The Nomad cluster where the target application is running.

## job
**Type: `string`**  
**Required: true**

The Nomad job name where the task is located.

## group
**Type: `string`**  
**Required: true**

The Nomad group with the job which contains the task.

## task
**Type: `string`**  
**Required: true**

The Nomad task to expose.

### port
**Type: [`port`](#type-port)**  
**Required: false**

A port stanza allows you to expose container ports on the host. This stanza can be specified multiple times.

```javascript
port {
  local = 80
  remote = "http"
  host = 8080
}
```

## Type `port`

A port stanza defines host to container communications

### local
**Type: `string`**  
**Required: true**

The local port in the container where the upstream can be reached. This port can be used by other containers 
and clusters on the same network.

### host
**Type: `string`**  
**Required: true**

The port on the machine running Shipyard used to connect the remote application.

### remote
**Type: `string`**  
**Required: true**

The remote port, name or number where the remote service is accessible.

### protocol
**Type: `string "tcp", "udp"`**  
**Required: false**
**Default: "tcp"**

The protocol to use when exposing the port, can be "tcp", or "udp".

### open_in_browser
**Type: `string`**  
**Required: false**
**Default: "/"**

When set a browser window will be automatically opened after theresource is created. Browser windows will open at the path specified by this property.

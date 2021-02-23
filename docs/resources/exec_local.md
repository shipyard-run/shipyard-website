---
id: exec_local
title: Local Exec
---

The `exec_local` resource allows the execution of arbitrary commands and scripts on the local machine. The command runs in
the local user space, and has access to all the environment variables that the user executing `shipyard run` has access
too. Additional environment variables, and the working directory for the command can be specified as part of the resource
stanza.

Log files for `exec_local` are written to `$HOME\.shipyard\logs\[name].log`

## Minimal Example

The following example will run the command `consul services register ./config/redis/hcl` and will wait for it to complete.
If the command takes longer than 30s then it will be automatically killed.

```javascript
exec_remote "exec_standalone" {
  cmd = "consul"
  args = [
    "services",
    "register",
    "./config/redis.hcl"
  ]

  env {
    key = "CONSUL_HTTP_ADDR"
    value = "http://consul.container.shipyard.run:8500"
  }

  timeout = "30s"
}
```

## Daemon Mode

The following example runs the command `consul agent -dev` and immediately returns leaving the command to run as a daemon which is 
not terminated when the `shipyard run` command completes.

Daemons either exit on their own or are killed when running `shipyard destroy`.

```javascript
exec_remote "exec_standalone" {
  cmd = "consul"
  args = [
    "agent",
    "-dev",
  ]

  daemon = true
}
```

## Parameters


### depends_on
**Type: []string**  
**Required: false**

Depends on allows you to specify resources which should be created before this one. In the instance of a destruction, this container will be destroyed before
resources in.

### command
**Type: string**  
**Required: false**

Command allows you to specify a command to execute when starting a container.

### args
**Type: []string**  
**Required: false**

Arguments passed to the  command to execute when starting a container. For example, to execute a command which installs Shipyard the following command and arguments can be used.

```javascript
cmd = "curl"

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

An environment stanza allows you to set environment variables which will be used by the command.

```javascript
env {
  key = "PATH"
  value = "/usr/local/bin"
}
```

### env_vars
**Type: map[string]string**  
**Required: false**

An env_vars parameter allows you to set environment variables for the command. 

```javascript
env_var = {
  "abc" = "123",
  "foo" = "bar"
}

### timeout
**Type: string**  
**Default: 30s**
**Required: false**

Timeout allows you to specify a maximum duration that a script can run for, it is specified using Go's duration syntax.
If the timeout period elapses before the command completes Shipyard will kill the command and fail the `run`.

When the `daemon` parameter is set to `true`, timeout is ignored.

```javascript
timeout = "30s" # 30 second timeout

timeout = "3m" # 3 minute timeout
```

### daemon
**Type: boolean**  
**Default: false**
**Required: false**

Daemon allows you to tell Shipyard to run the command as an unattended process. When this attribute is set to true
Shipyard will start the process but will not wait for it to complete. Unless the script or command exits it will
continue to run until the blueprint is destroyed with the `shipyard destroy` command.

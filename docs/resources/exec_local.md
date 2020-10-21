---
id: exec_local
title: Local Exec
---

The `exec_local` resource allows the execution of arbitrary commands and scripts on the local machine. The command runs in
the local user space, and has access to all the environment variables that the user executing `shipyard run` has access
too. Additional environment variables, and the working directory for the command can be specified as part of the resource
stanza.

## Minimal Example

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
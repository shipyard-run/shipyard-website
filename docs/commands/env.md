---
id: env
title: Env
---
The env command prints a formatted list of environment variables defined in a blueprint which can be interpreted by the operating system.

**Example blueprint defining environment variables - README.md**
```
---
title: "Example blueprint file"
author: "Nic Jackson"
slug: "example"
env:
  - KUBECONFIG=$HOME/.shipyard/config/k3s/kubeconfig.yaml
  - VAULT_ADDR=http://localhost:18200
  - VAULT_TOKEN=root
---

This blueprint contains environment variables which can be displayed using the "env" command.
```

## Command Usage
```shell
Usage:
  shipyard env [flags]

Examples:

  # Display environment variables
  shipyard env
  
  VAR1=value
  VAR2=value
  
  # Set environment variables on Linux based systems
  eval $(shipyard env)
    
  # Set environment variables on Windows based systems
  @FOR /f "tokens=*" %i IN ('shipyard env') DO @%


Flags:
  -h, --help   help for env
```
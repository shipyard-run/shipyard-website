---
id: env
title: Env
---

The env command prints a formatted list of environment variables defined in a blueprint which can be interpreted by the operating system.

**Example blueprint defining environment variables - README.md**

```shell
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

**Example defining environment variables using output resources**

```javascript
output "KUBECONFIG" {
  value = k8s_config("k3s")
}
```

## Command Usage

```shell
Prints environment variables defined by the blueprint

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
  Invoke-Expression "shipyard env" | ForEach-Object { Invoke-Expression $_ }

  # Unset environment variables on Linux based systems
  eval $(shipyard env --unset)

  # Unset environment variables on Windows based systems
  Invoke-Expression "shipyard env --unset" | ForEach-Object { Remove-Item $_ }


Flags:
  -h, --help    help for env
      --unset   When set to true Shipyard will print unset commands for environment variables defined by the blueprint
```
---
id: output
title: Output
---

The output resource allows you to define output variables which can be used with the Shipyard [output](/docs/commands/output) and [env](/docs/commands/env) commands.

## Simple example 

```javascript
output "KUBECONFIG" {
  value = "/path/to/kubeconfig.yaml"
}
```

## Example using Shipyard functions

```javascript
output "KUBECONFIG" {
  value = k8s_config("k3s")
}
```


## Parameters

### value
**Type: `string`**  
**Required: true**

Value to set for the output variable

---
id: output
title: Output
---

The output command shows the value of the `output` variables defined in a Blueprint. By default the output command returns a JSON formatted string containing all variables.

## Command Usage

```shell
Show the output variables

Usage:
  shipyard output [flags]

Flags:
  -h, --help   help for output
```

## Example

To show all variables defined in the system:

```shell
➜ shipyard output
{
  "KUBECONFIG": "/home/nicj/.shipyard/config/k3s/kubeconfig-docker.yaml"
}
```

To show a single variable:

```shell
➜ shipyard output KUBECONFIG
/home/nicj/.shipyard/config/k3s/kubeconfig-docker.yaml
```
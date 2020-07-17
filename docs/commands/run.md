---
id: run
title: Run
---

```shell
➜ yard-dev run --help
Run the supplied stack configuration

Usage:
  shipyard run [file] [directory] ... [flags]

Examples:

  # Recursively create a stack from a directory
  shipyard run ./-stack

  # Create a stack from a specific file
  shipyard run my-stack/network.hcl
  
  # Create a stack from a blueprint in GitHub
  shipyard run github.com/shipyard-run/blueprints//vault-k8s


Flags:
      --force-update     When set to true Shipyard ignores cached images or files and will download all resources
  -h, --help             help for run
      --no-browser       When set to true Shipyard will not open the browser windows defined in the blueprint
      --var strings      Allows setting variables from the command line, varaiables are specified as a key and value, e.g --var key=value. Can be specified multiple times
  -v, --version string   When set, run creates the specified resources using a particular Shipyard version
  -y, --y                When set, Shipyard will not prompt for conifirmation
```
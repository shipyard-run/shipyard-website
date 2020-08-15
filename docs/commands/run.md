---
id: run
title: Run
---

The `run` command reads Shipyard configuration files and uses them to create resources. The `run` command can be used either with a file `shipyard run file.hcl`, a directory `shipyard run ./`, or a GitHub repository `shipyard run github.com/shipyard-run/blueprints//vault-k8s`.

Run also has a number of flags which can be used to alter the behaviour:

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

## Flags ##

### force-update
**Type: `boolean`**  
**Required: false**  
**Default: false**

Shipyard caches Docker images, Helm Charts, and Blueprints downloaded from external sources. In the instance you would like to force shipyard to redownload this resource, for example you have a docker container using the `latest` tag and would like to update it to the most recent checksum. You can use the `force-update` flag.

### no-browser
**Type: `boolean`**  
**Required: false**  
**Default: false**

Shipyard allows you to optionally define that `
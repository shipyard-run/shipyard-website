---
id: run
title: Run
---

The `run` command reads Shipyard configuration files and uses them to create resources. The `run` command can be used either with a file `shipyard run file.hcl`, a directory `shipyard run ./`, or a GitHub repository `shipyard run github.com/shipyard-run/blueprints//vault-k8s`.

Run also has a number of flags which can be used to alter the behaviour:

```shell
➜ shipyard help run

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
  -h, --help             help for run
      --force-update     When set to true Shipyard ignores cached images or files and will download all resources
      --no-browser       When set to true Shipyard will not open the browser windows defined in the blueprint
      --var strings      Allows setting variables from the command line, varaiables are specified as a key and value, e.g --var key=value. Can be specified multiple times
      --vars-file string   Load variables from a location other than *.vars files in the blueprint folder. E.g --vars-file=./file.vars
  -v, --version string   When set, run creates the specified resources using a particular Shipyard version
  -y, --y                When set, Shipyard will not prompt for confirmation
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

Shipyard allows you to optionally override the behavior of resources which have browser open parameters. Setting this flag to true stops Shipyard from opening browser windows.

### var
**Type: `string`**  
**Required: false**  

The `var` flag allows you to set the value for Shipyard variables from the command line. Setting a variable with this flag takes precedence over any environment variables or variable files.  
This flag may be specified multiple times.

### vars-file
**Type: `string`**  
**Required: false**  

Allows you to specify the location of a variable file. By default Shipyard will attempt to load a `*.vars` file from the Blueprint folder, this flag allows you to specify an additional variables value file.

### version
**Type: `string`**  
**Required: false**  

Allows you to create resources with a different version of Shipyard than the installed version. Shipyard will automatically download the other version into a temporary location and run the command using this version. If Shipyard needs to download the version specified by the flag, the user will be prompted for action.

### y
**Type: `bool`**  
**Required: false**  

When specified, answers `yes` to any confirmation prompts for the user.

---
id: variable
title: Variables
---

The `variable` resource allows you to create modular and reusable configuration. Variables are defined using `variable` 
resouce, they allow the author of a blueprint to provide default values which can be overriden my the following methods:

* Variable definition files
* Flags provided to `shipyard run`
* Environment variables

Any variable defined is global to the entire configuration, including any modules used. This allows variables to be
overriden, however; care needs to be taken when defining variables to ensure they do not clash. When building a reusable
module it is recommended that variables are prefixed with the module name.

## Simple example

The following eample defines two variables `version` which has a value `1.6.1`, and `subnet` which has a value of
`10.6.0.0/16`. To use these variables inside the configuration you use the `var.[variable_name]` syntax. When 
using a varialbe on its own it is not required to encapsulate this in a string, as can be seen in the subnet example
`subnet = var.subnet`, however; should you need to concatonate this variable with another then you need to encapsulate
the `var.[variable_name]` inside the parentheses `${}`, this is seen in the container image stanza,
`name = "consul:${var.version}"`.

```javascript
variable "version" {
  default = "1.6.1"
}

variable "subnet`" {
  default = "10.6.0.0/16"
}

network "onprem" {
  subnet = var.subnet
}

container "consul" {
  image   {
    name = "consul:${var.version}"
  }

  command = ["consul", "agent", "-dev"]

  network   {
    name = "network.onprem"
    ip_address = "10.6.0.200"
  }
}
```

## Complex variables

In addition to specifying simple string variables, it is also possible to define variables which are maps, or arrays. 
The following example shows the use of both of these types. In addition to the example shown below, a map can also contain
an array and an array a map allowing you to mix complex types together.

```javascript
variable "subnet" {
  default = {
    main = "10.6.0.0/16"
    consul = "10.7.0.0/16"
  }
}

variable "command" {
  default = [
    "consul",
    "agent",
    "-dev"
  ]
}

network "onprem" {
  subnet = var.subnet.main
}

container "consul" {
  command = var.command
}
```

## Overriding variables

The `variable` resource allows the specification of a default value for a variable, overriding these variables can be 
performed using the three following methods:

### Variable files

When reading a configuration folder Shipyard will auotmatically search for and parse files with the extension `.vars`.
Variable files allow you to set the value for complex and simple variables and are specified as seen in the following example:

```javascript
version = "1.8.1"

subnet = {
  main = "192.1.0.0/16"
  consul = "192.2.0.0/16"
}
```

In addition to variable files being automatically loaded by Shipyard from the module folder you can specify external files
using the command line flag `--vars-file`. There is no naming convention for variable files specified in this way.

```shell
shipyard run --vars-file = ./myvariables.defaults ./module 
```

### Command line arguments

It is possible to override variables using command line arguments, the `run` and `test` commands have the flag
`--var` which has a value `variable=value` pair that can be used to set a varaible. The `--var` flag can be specified
multiple times.

```shell
shipyard run --var "version=1.9.1" --var "another=value" ./module 
```

### Environment variables 

Lastly you can specify variables using environment variables. To define a variable using an environment variable you 
prefix the name of the variable with `SH_VAR_`, for example, the variable `version` when set as an environment variable
would be specified as `SH_VAR_version`.

```shell
export SH_VAR_version=1.8.2
```

### Variable load order

When using variables there is a defined order of precidence. The following list shows the priority order for setting
varaibles.

* `variable` stanza block
* `.vars` files found in the config folder
* environment variables `SH_VAR_[name]`
* command line argumens specified with the `--var` flag
* variable files specified using the `--var-file` command line flag

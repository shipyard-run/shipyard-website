---
id: template
title: Template
---

The `template` resource allows text templates using [Go's template format](https://golang.org/pkg/text/template/)
to be processed as part of the resource creation process. For example you can use the template resource 
to prepare configuration files for your applications.

Variables can be defined as a map in the `vars` attribute which are available for substitution using the root
Go template object `.Vars`. For example to replace insert the value of the vars item `data_dir` the following
syntax can be used.

```
data_dir = "#{{ .Vars.data_dir }}"
```

All supported features o Go Templates such as variable substitution, loops and conditional statements are supported
by the Shipyard implementation.

To ensure that Shipyard templates can produce content which could be interpreted by standard Go templates, and which
does not clash with the interpolation syntax, the delimters have been modifed from `{{` and `}}` to `#{{` and `}}`.

## HereDoc Example

The following example shows how the template can be embedded into the resource stanza using HereDoc syntax.

```javascript
template "consul_config" {

  source = <<EOF
data_dir = "#{{ .Vars.data_dir }}"
log_level = "DEBUG"

datacenter = "dc1"
primary_datacenter = "dc1"

server = true

bootstrap_expect = 1
ui = true

bind_addr = "0.0.0.0"
client_addr = "0.0.0.0"
advertise_addr = "10.6.0.200"

ports {
  grpc = 8502
}

connect {
  enabled = true
}
EOF

  destination = "./consul_config/consul.hcl"

  vars = {
    data_dir = "/tmp"
  }
}
```

The file produced from this example would be as follows:

```
data_dir = "/tmp"
log_level = "DEBUG"

datacenter = "dc1"
primary_datacenter = "dc1"

server = true

bootstrap_expect = 1
ui = true

bind_addr = "0.0.0.0"
client_addr = "0.0.0.0"
advertise_addr = "10.6.0.200"

ports {
  grpc = 8502
}

connect {
  enabled = true
}
```

## External File Example

To leverage external files you can use the `file` function which loads a file returning a string. This example
also shows how the `depends_on` attribute can be used to ensure a template is processed before it is consumed.

```javascript
template "consul_config" {

  source = file("./mytemplate.hcl") 
  destination = "./consul_config/consul.hcl"

  vars = {
    data_dir = "/tmp"
  }
}

container "consul" {
  depends_on = ["template.consul_config"]

  image   {
    name = "consul:${var.consul_version}"
  }

  command = ["consul", "agent", "-config-file=/config/consul.hcl"]

  volume {
    source      = "./consul_config"
    destination = "/config"
  }
}
```

## Inline Variables

In addtion to the Go template syntax when using HereDoc it is possible to direcly inline Shipyard variables 
and functions as shown by the following example.

```javascript
template "consul_config" {

  source = <<EOF
data_dir = "${data_dir()}"
log_level = "DEBUG"

datacenter = "${var.datacenter}"

server = ${var.server}
EOF

  destination = "./consul_config/consul.hcl"

}
```

## Functions

The `template` resource provides custom functions that can be used inside your templates as shown in the example below.

```javascript
template "consul_config" {

  source = <<EOF

file_content = "#{{ file "./myfile.txt" }}"
quote = #{{ .Var.something | quote }} 
trim = #{{ .Var.with_whitespace | trim | quote }}

EOF

  destination = "./consul_config/consul.hcl"

}
```

### file [path]

Reads the contents of a file from the given path

```shell
# given a file ./myfile.txt with the contents "foo bar"

file "./myfile.txt" would return "foo bar"
```

### quote [string]

Returns the original string wrapped in quotations, quote can be used with the Go template pipe modifier.

```shell
$ given the string abc

quote "abc" would return the value "abc"
```

### trim [string]

Removes whitespace such as carrige returns and spaces from the begining and the end of the string, can be used with the Go template pipe modifier.

```shell
$ given the string abc

trim " abc " would return the value "abc"
```

## Parameters


### depends_on
**Type: []string**  
**Required: false**

Depends on allows you to specify resources which should be created before this one. In the instance of a destruction, this container will be destroyed before
resources in.

### source
**Type: string**  
**Required: true**

The template source specified as a string, it is possible to leverage the `file` function to load external files and HereDoc syntax for multi line templates.

### destination
**Type: string**  
**Required: true**

The destination file that will be written by the template resource. If relative file is specified, Shipyard will replace this to be an absolute path relative
to the config file containing the resource.

### vars
**Type: map[string]string**  
**Required: false**

Variables that can be used within templates. [Shipyard functions](/docs/resources/functions) and [Shipyard variables](/docs/resources/variable) can be used
in this map.

```javascript
vars = {
 my_home = env("HOME")
 docker_ip = docker_ip()
 my_variable = var.consul
}
```

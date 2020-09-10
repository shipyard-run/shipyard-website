---
id: module
title: Module
---

The module resource allows a blueprint to reference other files or blueprints. Blueprints can be referenced from the local file system or from GitHub 
repositories


## Minimal Example

```javascript
network "onprem" {
  subnet = "10.6.0.0/16"
}

# Reference a local Blueprint stored in a sub folder
module "consul" {
  source = "./sub_module"
}

# Reference a remote Blueprint stored in a GitHub repository
module "nomad" {
  source = "github.com/shipyard-run/blueprints//consul-nomad"
}
```

#### Run this example:

```shell
shipyard run github.com/shipyard-run/shipyard-website/examples//modules
Running configuration from:  ./examples/modules

2020-04-27T08:49:04.205+0100 [DEBUG] Statefile does not exist
2020-04-27T08:49:04.206+0100 [INFO]  Creating Network: ref=cloud
2020-04-27T08:49:04.206+0100 [INFO]  Creating Network: ref=onprem
2020-04-27T08:49:19.232+0100 [INFO]  Creating Container: ref=consul
2020-04-27T08:49:19.323+0100 [DEBUG] Image exists in local cache: image=consul:1.7.2
# ...
```

## Parameters

### source
**Type: string**  
**Required: true**

Source of the Blueprint to include, can either be a local path `./sub_folder` or a remote GitHub repository `github.com/shipyard-run/blueprints//consul-nomad`

### depends_on
**Type: []string**  
**Required: false**

Depends On allows you to attach dependencies to module creation, dependencies in Shipyard control the order by which resources are created and destroyed. In the following example the module `nomad` would not be created until all the resources defined by module `consul` have been created.

```javascript
module "consul" {
  source = "./sub_module"
}

// Reference a remote Blueprint stored in a GitHub repository
module "nomad" {
  depends_on = ["module.consul"]
  source = "github.com/shipyard-run/blueprints//consul-nomad"
}
```

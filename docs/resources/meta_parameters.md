---
id: meta
title: Meta Parameters
---

Meta parameters are common to all resources and are applied in the same way that resource specific parameters are added.

## Parameters

### depends_on
**Type: []string**  
**Required: false**

Depends on allows you to specify resources which should be created before this one. In the instance of a destruction, this container will be destroyed before
resources in.

In the following example the resource container `b` would only be created or destroyed once container `a` has completed sucessfully.

```yaml
container "a" {
#...
}

container "b" {
  depends_on = ["container.a"]
#...
}
```

### disabled
**Type: boolean**  
**Required: false**
**Default: false**

When set to true the resource or module will not be created or destroyed.

In the following example the resource container `a` would be created and destroyed but container `b` and 
any resources defined by module `a` or its submodules would not. 

```yaml
container "a" {
#...
}

container "b" {
  disabled = true
#...
}

module "a" {
  disabled = true
#...
}
```
---
id: copy
title: Copy
---

The `copy` resource allows you to copy files and directories from one location to another. Unless the `permissions` attribute is specified
all files are copied along with their original permissions.

## Minimal example

```shell
copy "cd_consul_certs" {
  source = "./myfolder"
  destination = "./mydestination"
  permissions = "0444"
}
```

## Parameters

### source
**Type: `string`**  
**Required: true**  

The source file or directory to copy, when source is a directory the `copy` resource will recurisively copy all files and directories.

### destination
**Type: `string`**  
**Required: true**  

The destination to copy the contents to. When copying a file if the destination is a file, you must specify the destination including 
the filename.

### permissions
**Type: `string`**  
**Required: false**  

File permissions to use when copying the files and directries specified as an Linux octal mask, i.e. `0755`.

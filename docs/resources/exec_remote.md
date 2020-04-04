---
id: exec_remote
title: Remote Exec
---

## Minimal Example

```javascript
exec_remote "unique_name" {
  target = "container.vault"

  command = "/files.sh"
}

container "vault" {
  image {
    name = "hashicorp/vault-enterprise:1.4.0-rc1_ent"
  }

  volume {
    source = "./files"
    destination = "/files"
  }
}
```
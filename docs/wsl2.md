---
id: wsl2
title: Windows WSL2
---

## Windows WSL2 and Docker:
To access resources Shipyard uses magic URLs such as `http://consul.container.shipyard.run:8500`. At present this is the same as `http://localhost:8500`, however the fully qualified URLs will be required in a later release due to planned changes to ingress to allow a sinlge port to be shared with multiple
resources. The URI `container.shipyard.run` has a wildcard IPV4 DNS entry mapping for `127.0.0.1`, and a wildcard IPV6 DNS entry mapping for `::1`.

At present there is a bug with WSL2 and Docker bindings for `localhost` when accessing via the `IPv4` IP address `127.0.0.1`, not the host name `localhost`. In order for magic URLs to function correctly Shipyard requires `IPv6` networking to be enabled, as this is not affected by the Docker bind bug.

[https://github.com/microsoft/WSL/issues/4671](https://github.com/microsoft/WSL/issues/4671)

An alternate workaround for this issue is to simply use the `localhost` equivalent for any magic URL. For example:

```
http://consul.container.shipyard.run:8500 > http://localhost:8500
http://k8s.ingress.shipyard.run:8443      > http://localhost:8443
```

This issue only affects the access of Shipyard resources from outside the WSL2 container, resolution inside the container should function correctly with IPv4.
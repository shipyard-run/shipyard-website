---
id: wsl2
title: Windows and WSL2
---

## Accessing resrouces with IPv4 Networks

To access resources in Shipyard you can use magic URLs such as `http://consul.container.shipyard.run:8500`, `http://[name].[type].shipyard.run:[port]`, Shipyard uses DNS entries for `IPv4` resolving to `127.0.0.1` and `IPv6` resolving to `::1`. 

At present a bug exists with WSL2 and Docker bindings for `localhost` when accessing via the `IPv4` IP address `127.0.0.1` not the host name `localhost`. This means that services running in Docker on WSL2 can not be accessed via the `localhost` ip address `127.0.0.1` from outside the WLS2 container (the hostname `localhost` functions correctly). In order for magic URLs to function on WSL2, Shipyard requires `IPv6` networking to be enabled. `IPv6` is not affected by the Docker bind bug and resources can be accessed both internally and externally using the ip address `::1`.

[https://github.com/microsoft/WSL/issues/4671](https://github.com/microsoft/WSL/issues/4671)

If you already have `IPv6` networking enabled you do not need to change any settings, this bug will only manifest when you only have `IPv4` networks.

An alternate workaround for this issue is to simply use the `localhost` equivalent for any magic URL, for example:

```
http://consul.container.shipyard.run:8500 > http://localhost:8500
http://k8s.ingress.shipyard.run:8443      > http://localhost:8443
```

This issue only affects the access of Shipyard resources from outside the WSL2 container, resolution inside the container should function correctly with IPv4.
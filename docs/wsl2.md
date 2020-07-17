---
id: wsl2
title: Windows and WSL2
---

## Accessing resources with IPv4 Networks

To access resources in Shipyard you can use magic URLs such as `http://consul.container.shipyard.run:8500`, `http://[name].[type].shipyard.run:[port]`. Magic URLs work as Shipyard uses wildcard DNS entries for `[type].shipyard.run`, with `IPv4` resolving to `127.0.0.1` and `IPv6` resolving to `::1`. 

There is currently a bug with WSL2 and Docker bindings for `localhost` when accessed via the `IPv4` IP address `127.0.0.1`. This means that services running in Docker on WSL2 can not be accessed via the ip address `127.0.0.1` from outside the WLS2 container (the hostname `localhost` functions correctly). In order for magic URLs to function on WSL2, Shipyard requires `IPv6` networking to be enabled. `IPv6` is not affected by the Docker bind bug and resources can be accessed both internally and externally.

[https://github.com/microsoft/WSL/issues/4671](https://github.com/microsoft/WSL/issues/4671)

If you already have `IPv6` networking or a `IPv4` and `IPv6` networking enabled you do not need to change any settings, this bug only affects users who only have `IPv4` networking.

An alternate workaround for this issue is to use the `localhost` equivalent for any magic URLs, for example:

```
http://consul.container.shipyard.run:8500 > http://localhost:8500
http://k8s.ingress.shipyard.run:8443      > http://localhost:8443
```

This issue also only affects the access of Shipyard resources from outside the WSL2 container, resolution inside the container should function correctly with IPv4.

### Why Magic URLs?
When exposing a service or resource to the local host Shipyard currently requires services to be exposed using unique ports. For example the resources `app-a.container.shipyard.run` and `app-b.container.shipyard.run` can not both expose their services on the same port because individual resources currently bind to the hosts IP address. From version v0.2.0, Shipyard will move to a shared ingress. Multiple resources can bind to a shared host port with traffic routed to the correct resource using HTTP Host Headers.
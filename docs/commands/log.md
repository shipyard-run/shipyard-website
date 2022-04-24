---
id: log
title: Log
---

The log command allows the tailing of logs from Shipyard resources.

**Example tailing logs for all running resources**

```shell
➜ shipyard log
[docker-cache]       # Secondary tier caching of manifests; configure via MANIFEST_CACHE_SECONDARY_REGEX and MANIFEST_CACHE_SECONDARY_TIME
[docker-cache]       location ~ ^/v2/(.*)/manifests/(.*)(\d|\.)+(.*)(\d|\.)+(.*)(\d|\.)+ {
[docker-cache]           set $docker_proxy_request_type "manifest-secondary";
[docker-cache]           proxy_cache_valid 60d;
[docker-cache]           include "/etc/nginx/nginx.manifest.stale.conf";
[users-1]   Aug 10 12:20:16 users-1 consul[80]: 2021-08-10T12:20:16.994Z [ERROR] agent.client: RPC failed to server: method=Intention.Match server=10.0.0.3:8300 error="rpc error making call: Permission denied"
[users-1]   Aug 10 12:20:17 users-1 consul[80]: 2021-08-10T12:20:17.642Z [DEBUG] agent.client.memberlist.lan: memberlist: Stream connection from=10.0.0.3:41084
[users-1]   Aug 10 12:20:18 users-1 consul[174]: [2021-08-10 12:20:18.290][174][debug][main] [source/server/server.cc:209] flushing stats
[server]   Aug 10 12:20:47 server consul[58]: 2021-08-10T12:20:47.613Z [WARN]  agent.server.intentions: Operation on intention prefix denied due to ACLs: prefix=users accessorID=
[server]   Aug 10 12:20:47 server consul[58]: 2021-08-10T12:20:47.644Z [DEBUG] agent.server.memberlist.lan: memberlist: Initiating push/pull sync with: users-1 10.0.0.2:8301
[server]   Aug 10 12:20:48 server consul[58]: 2021-08-10T12:20:48.152Z [WARN]  agent.server.intentions: Operation on intention prefix denied due to ACLs: prefix=users accessorID=
[users-1]   Aug 10 12:20:48 users-1 consul[80]: 2021-08-10T12:20:48.152Z [ERROR] agent.client: RPC failed to server: method=Intention.Match server=10.0.0.3:8300 error="rpc error making call: Permission denied"
[users-1]   Aug 10 12:20:48 users-1 consul[174]: [2021-08-10 12:20:48.309][174][debug][main] [source/server/server.cc:209] flushing stats
```

**Example tailing logs for only the container resource named users-1**

```shell
➜ shipyard log container.users-1
[users-1]   Aug 10 12:22:45 users-1 consul[80]: 2021-08-10T12:22:45.305Z [ERROR] agent.client: RPC failed to server: method=Intention.Match server=10.0.0.3:8300 error="rpc error making call: Permission denied"
[users-1]   Aug 10 12:22:45 users-1 consul[80]: 2021-08-10T12:22:45.669Z [ERROR] agent.client: RPC failed to server: method=Intention.Match server=10.0.0.3:8300 error="rpc error making call: Permission denied"
[users-1]   Aug 10 12:22:46 users-1 consul[80]: 2021-08-10T12:22:46.192Z [ERROR] agent.client: RPC failed to server: method=Intention.Match server=10.0.0.3:8300 error="rpc error making call: Permission denied"
```

## Command Usage

```shell
➜ shipyard logs --help
Tails logs for running shipyard resources

Usage:
  shipyard log <command>  [flags]

Aliases:
  log, logs

Examples:

  # Tail logs for all running resources
        shipyard log

        # Tail logs for a specific resource
        shipyard log container.nginx
```
---
id: push
title: Push
---
The push command allows a local Docker image to be pushed to a Nomad or Kubernetes cluster. This enables
local development flow for application containers without needing to push images to a remote registry. 

## Command Usage

```shell
 yard-dev push --help
Push a local Docker image to a cluster

Usage:
  shipyard push [image] [cluster]

Examples:
yard push nicholasjackson/fake-service:v0.1.3 k8s_cluster.k3s

Flags:
      --force-update   When set to true Shipyard will ignore cached images or files and will download all resources
  -h, --help           help for push
```

## Example

```shell
➜ yard-dev push nicholasjackson/vault-k8s-app:latest k8s_cluster.k3s                    
Pushing image nicholasjackson/vault-k8s-app:latest to cluster k8s_cluster.k3s

2020-04-29T22:28:20.930+0100 [INFO]  Pushing to container: id=faff962223e453e93ec52139b39e75b3e9abcaf86b11ea6de72fb0db01de5355 image=nicholasjackson/vault-k8s-app:latest
2020-04-29T22:28:21.034+0100 [DEBUG] Image exists in local cache: image=nicholasjackson/vault-k8s-app:latest
2020-04-29T22:28:21.034+0100 [DEBUG] Writing docker images to volume: images=[nicholasjackson/vault-k8s-app:latest] volume=images.volume.shipyard.run
2020-04-29T22:28:21.138+0100 [DEBUG] Image exists in local cache: image=alpine:latest
2020-04-29T22:28:21.138+0100 [INFO]  Creating Container: ref=temp-import
2020-04-29T22:28:21.533+0100 [DEBUG] Copying image to container: image=nicholasjackson/vault-k8s-app:latest
2020-04-29T22:28:21.882+0100 [DEBUG] 
2020-04-29T22:28:22.202+0100 [DEBUG] �unpacking docker.io/nicholasjackson/vault-k8s-app:latest (sha256:27e81941b23052e4073a2916ffcc3ad14187079aa1dffcbb7b17ccf2f14a2f7d)...
2020-04-29T22:28:22.250+0100 [DEBUG] done
```
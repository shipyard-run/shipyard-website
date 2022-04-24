---
id: podman
title: Podman support
---

Shipyard supports Podman through the Docker API that is bundled with podman, however out of the box Podman 
requires a little configuration as by default it does not enable DNS Lookup, the Docker API, and it has
no default registries configured.

## Configuring DNS

To enable DNS resolution for pods Podman requires the CNI plugin [dnsname](https://github.com/containers/dnsname).

At present there is no binary build for `dnsname`, you can clone and build it with the following command

```shell
mkdir -p /usr/libexec/cni

git clone https://github.com/containers/dnsname.git

cd dnsname

make
sudo cp ./bin/dnsname /usr/libexec/cni
```

## Install and configure `dnsmasaq`
`dnsname` uses `dnsmasq` for resolution, you can install `dnsmasq` from your local package manager.
You may find that resolvd is listening on port 53 and `dnsmasq` will not start, to replace resolvd
with `dnsmasq` you can use the following script

```
echo "disable resovld listening on 53"
sudo /bin/bash -c 'echo "DNSStubListener=no" >> /etc/systemd/resolved.conf'
sudo /bin/bash -c 'echo "DNS=8.8.8.8" >> /etc/systemd/resolved.conf'
sudo systemctl restart systemd-resolved.service

echo "configure dnsmasq"
sudo /bin/bash -c 'echo "server=8.8.8.8" >> /etc/dnsmasq.conf'
sudo /bin/bash -c 'echo "server=1.1.1.1" >> /etc/dnsmasq.conf'
sudo systemctl restart dnsmasq

sudo /bin/bash -c 'echo "127.0.0.1 ubuntu" >> /etc/hosts'
```

## Enabling root Podman sock
Shipyard uses the Docker API that is available from Podman, by default this is disabled, to enable
execute the following script to enable the socket and set the permission to the group `docker` that
is commonly used by the docker engine. You can use other groups, just ensure that the user running
Shipyard is in that group.

```shell
sudo sed '/^SocketMode=.*/a SocketGroup=docker' -i /lib/systemd/system/podman.socket
sudo chmod +x /run/podman

sudo systemctl enable podman.socket
sudo systemctl enable podman.service
sudo systemctl start podman.service
sudo podman info
```

## Enable docker.io in the `podman` registries

By default no authorized registries are enabled for podman, pulling an image will result in an error if 
at least the `docker.io` registry where all the Shipyard containers are stored is not set. The following
command enables the `docker.io` in the registry search.

```shell
echo -e "[registries.search]\nregistries = ['docker.io']" | sudo tee /etc/containers/registries.conf
```

## Setting DOCKER_HOST

For Shipyard to use Podman you need to set the `DOCKER_HOST` environment variable to the path of your
podman sock.

```shell
export DOCKER_HOST=unix:///run/podman/podman.sock
```

Once this has been set, running `shipyard check` should show the following output. If you see `ERROR` for 
Podman, double check that the environment variable is set. Once `DOCKER_HOST` is set you will also be able
to use the `docker` cmd to talk to the `podman` server. `docker ps` should result in the same output as
`sudo podman ps`.

```shell
➜ shipyard check

###### SYSTEM DIAGNOSTICS ######
 [  ERROR  ] Docker
 [   OK    ] Podman
 [   OK    ] Git
 [ WARNING ] xdg-open
```
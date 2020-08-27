---
id: install
title: Installing Shipyard
---

Shipyard runs on macOS, Linux and Windows (natively and with WSL2)

## Prerequisites

To use Shipyard you need a recent version of Docker and the Git CLI installed on your system.

* [Docker](https://docs.docker.com/) 
* [Git](https://git-scm.com/)

## Quick install (Linux, Mac and Windows WSL2)

The quick install script allows you to easily install the latest version of Shipyard. Run the following command
in your terminal, the install script will prompt you for administrator access if required.

```shell
curl https://shipyard.run/install | bash

################################
Installing Shipyard to /usr/local/bin/shipyard

Please note: You may be prompted for your password

To remove Shipyard and all configuration use the command "shipyard uninstall"
Downloading https://github.com/shipyard-run/shipyard/releases/download/v0.1.0/shipyard_0.1.0_linux_x86_64.tar.gz
/usr/bin/sudo
[sudo] password for nicj: 

Shipyard version: 0.0.10

###### SYSTEM DIAGNOSTICS ######
 [   OK    ] Docker
 [   OK    ] Git
 [   OK    ] xdg-open
```

## Brew for Mac

Shipyard is published as a [Brew](https://brew.sh) tap to install Shipyard using Homebrew run the following command in your terminal:

```shell
brew install shipyard-run/homebrew-repo/shipyard
```

## Chocolatey for Windows

To install Shipyard on Windows (not Windows Subsystem WSL or WSL2), you can use the [Chocolatey](https://chocolatey.org/packages/shipyard) package.
With Chocolatey installed, open a new powershell or command prompt and run the following command:

```shell
choco install shipyard
```

## Debian Packages

Shipyard can be installed from the official package in Gemfury's repository, to install shipyard first add the repo to `apt`,
and update the source lists.

```
echo "deb [trusted=yes] https://apt.fury.io/shipyard-run/ /" | sudo tee -a /etc/apt/sources.list.d/fury.list
sudo apt-get update
```

You can then install Shipyard with the following command:

```
sudo apt-get install shipyard
```

## RPM Packages

If you are using an operating system which supports RPM packages Shipyard can be install from the Gemfury `yum` repository.
To install Shipyard, add the `yum` repo to your list of repositories.

```
echo "[fury] 
name=Gemfury Private Repo 
baseurl=https://yum.fury.io/shipyard-run/ 
enabled=1 
gpgcheck=0" | sudo tee -a /etc/yum/repos.d/fury.repo
```

You can then install Shipyard with the following command:

```
yum install shipyard
```

## Github Releases

In addition to the above methods, we maintain Debian, RPM, and other packages in our GitHub releases. You can download
the latest packages from the following location.

[https://github.com/shipyard-run/shipyard/releases](https://github.com/shipyard-run/shipyard/releases)

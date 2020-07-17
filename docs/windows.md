---
id: windows
title: Running Shipyard on Windows
sidebar_label: Running on Windows
---

This guide is for installing Shipyard with Docker for Windows, if you are using WSL or WSL2 please follow the Linux guide.

## Install the Shipyard Binary

Download the latest release from [https://github.com/shipyard-run/shipyard/releases](https://github.com/shipyard-run/shipyard/releases)

```shell
D:\Downloads>dir
 Volume in drive D is Data
 Volume Serial Number is C61C-8C89

 Directory of D:\Downloads

01/15/2020  09:17 AM    <DIR>          .
01/15/2020  09:17 AM    <DIR>          ..
01/10/2020  04:24 PM    <DIR>          charts-master
01/10/2020  04:23 PM         6,466,159 charts-master.zip
01/10/2020  11:53 AM       876,834,520 Docker Desktop Installer.exe
01/10/2020  11:53 AM       239,105,000 DuetSetup-1-8-4-3.exe
01/10/2020  11:54 AM       141,854,352 EasyCanvas_2.0.44.0_Setup.exe
01/10/2020  10:55 AM         3,668,506 Mockup.png
01/10/2020  07:40 PM            21,157 Order-2362585-Docs-070142.pdf
01/13/2020  08:16 AM            21,157 Order-2362585-Docs-080111.pdf
01/13/2020  08:11 AM            21,157 Order-2362585-Docs-080144.pdf
01/14/2020  11:01 AM           111,999 Sarah Young - Domaine Expertise Interview 2020-01-14.pdf
01/10/2020  10:45 AM        62,614,725 Simple-Coffee-Cup-Mockup.zip
01/15/2020  09:17 AM        62,487,552 Unconfirmed 976937.crdownload
              11 File(s)  1,393,206,284 bytes
               3 Dir(s)  1,992,268,275,712 bytes free
```

## Configuring Docker

Install Docker for Windows

Docker for windows needs drives enabled, select the drives you want to share with Docker, this needs to be the drive where your HOME folder is located (normally C:) and any drives from where you plan to run Shipyard configuration.

![](/img/docs/windows/docker_1.png)

Press Apply and when prompted enter your password

![](/img/docs/windows/docker_2.png)

Docker desktop will now restart

---
title: Simple Nomad Example
author: Nic Jackson
slug: nomad_cluster
env:
  - NOMAD_HTTP_ADDR=${nomad_http_addr("dev")}
---

Simple single node Nomad cluster
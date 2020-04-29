network "local" {
  subnet = "10.6.0.0/16"
}

container "consul" {
  image   {
    name = "consul:1.7.2"
  }

  network {
    name = "network.local"
  }
  
  command = ["consul", "agent", "-dev","-client","0.0.0.0"]

  port {
    local = 8500
    remote = 8500
    host = 8500
  }

  health_check {
    http = "http://consul.container.shipyard.run:8500/v1/status/leader"
    timeout = "10s"
  }
}

exec_remote "exec_standalone" {
  depends_on = ["container.consul"]

  image {
    name = "consul:1.7.2"
  }
  
  network {
    name = "network.local"
  }

  cmd = "consul"
  args = [
    "services",
    "register",
    "/config/redis.hcl"
  ]

  // Mount a volume containing the config
  volume {
    source = "./config"
    destination = "/config"
  }

  env {
    key = "CONSUL_HTTP_ADDR"
    value = "http://consul.container.shipyard.run:8500"
  }
}
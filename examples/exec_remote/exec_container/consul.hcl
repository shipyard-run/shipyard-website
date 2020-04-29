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
  
  // Mount a volume containing the config, the volume must be mounted
  // here as it is not possible to add volumes after a container has been created.
  volume {
    source = "./config"
    destination = "/config"
  }

  health_check {
    http = "http://consul.container.shipyard.run:8500/v1/status/leader"
    timeout = "10s"
  }
}

exec_remote "exec_container" {
  target = "container.consul"

  cmd = "consul"
  args = [
    "services",
    "register",
    "/config/redis.hcl"
  ]
}
container "consul" {
  image   {
    name = "consul:1.7.3"
  }

  command = ["consul", "agent", "-config-file=/config/consul.hcl"]

  volume {
    source      = "./files"
    destination = "/config"
  }

  network  {
    name = "network.local"
  }
}
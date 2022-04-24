container "consul" {
  image {
    name = "consul:1.10.1"
  }

  command = ["consul", "agent", "-config-file=/config/consul.hcl"]

  volume {
    source      = "./files"
    destination = "/config"
  }

  network {
    name = "network.local"
  }
}
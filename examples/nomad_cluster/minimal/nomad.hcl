nomad_cluster  "dev" {
  network {
    name = "network.local"
  }
  
  env {
    key = "CONSUL_SERVER"
    value = "consul.container.shipyard.run"
  }
}

network "local" {
  subnet = "10.0.0.1/24"
}
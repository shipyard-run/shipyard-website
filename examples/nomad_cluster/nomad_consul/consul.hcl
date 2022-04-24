template "consul_server_config" {

  source = <<-EOS
  data_dir = "/tmp/"
  log_level = "DEBUG"

  datacenter = "dc1"
  primary_datacenter = "dc1"

  server = true

  bootstrap_expect = 1
  ui = true

  bind_addr = "0.0.0.0"
  client_addr = "0.0.0.0"

  ports {
    grpc = 8502
  }

  connect {
    enabled = true
  }
  EOS

  destination = "${data("config")}/consul_server_config.hcl"
}

container "consul" {
  depends_on = ["template.consul_server_config"]

  image {
    name = "consul:1.10.1"
  }

  command = ["consul", "agent", "-config-file=/config/config.hcl"]

  volume {
    source      = "${data("config")}/consul_server_config.hcl"
    destination = "/config/config.hcl"
  }

  network {
    name = "network.cloud"
  }

  port {
    local  = 8500
    remote = 8500
    host   = 8500
  }
}
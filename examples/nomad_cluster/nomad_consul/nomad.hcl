template "consul_agent_config" {
  source = <<-EOS
  datacenter = "dc1"
  retry_join = ["consul.container.shipyard.run"]
  EOS

  destination = "${data("config")}/consul_agent_config.hcl"
}

nomad_cluster "dev" {
  depends_on   = ["template.consul_agent_config"]
  client_nodes = "${var.client_nodes}"

  network {
    name = "network.cloud"
  }

  consul_config = "${data("config")}/consul_agent_config.hcl"
}

nomad_job "application" {
  cluster = "nomad_cluster.dev"

  paths = [
    "./app_config/web.nomad",
    "./app_config/api.nomad"
  ]

  health_check {
    timeout    = "60s"
    nomad_jobs = ["web", "api"]
  }
}

nomad_ingress "web" {
  cluster = "nomad_cluster.dev"
  job     = "web"
  group   = "apps"
  task    = "fake_service"

  port {
    local  = 19090
    remote = "http"
    host   = 19090
  }

  network {
    name = "network.cloud"
  }
}
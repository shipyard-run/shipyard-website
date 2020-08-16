k8s_cluster "k3s" {
  driver  = "k3s"
  version = "v1.17.4-k3s1"

  network {
    name = "network.local"
  }
}

k8s_config "app" {
  cluster = "k8s_cluster.k3s"

  paths = ["./k8s_app/"]
  wait_until_ready = true
}

k8s_ingress "app" {
  cluster = "k8s_cluster.k3s"

  network {
    name = "network.local"
  }

  deployment  = "web-deployment"

  port {
    local  = 9090
    remote = 9090
    host   = 9090
    open_in_browser = "/"
  }
}

output "KUBECONFIG" {
  value = "${k8s_config("k3s")}"
}
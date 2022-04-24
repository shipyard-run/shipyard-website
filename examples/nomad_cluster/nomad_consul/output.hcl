output "NOMAD_ADDR" {
  value = cluster_api("nomad_cluster.dev")
}

output "CONSUL_HTTP_ADDR" {
  value = "http://localhost:8500"
}
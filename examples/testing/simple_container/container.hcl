container "app" {
  image   {
    name = "nicholasjackson/fake-service:v0.13.2"
  }

  port {
    local = 9090
    remote = 9090
    host = 9090
  }
}
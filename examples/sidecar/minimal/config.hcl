container "app" {
  image {
    name = "nicholasjackson/fake-service:v0.9.0"
  }

  env {
    key = "LISTEN_ADDR"
    value = "127.0.0.1:9090"
  }

  # The app does not directly expose port 80
  # Envoy in the sidecar is running on this Port
  # Sidecars can not directly create ports as they attach to the containers
  # network
  port {
    local = 80
    remote = 80
    host = 8080
  }
}

sidecar "envoy" {
  target = "container.app"
  
  image {
    name = "envoyproxy/envoy:v1.14.1"
  }

  command = ["envoy", "-c", "/config/envoy.yaml"]

  volume {
    source = "./envoyconfig.yaml"
    destination = "/config/envoy.yaml"
  }
}

network "cloud" {
    subnet = "10.0.0.0/16"
}
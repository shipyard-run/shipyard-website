container "alpine" {
  image {
    name = "alpine:latest"
  }
}

docs "docs" {
  network {
    name = "network.local"
  }

  port = 8080
  open_in_browser = true

  path = "./pages"

  index_title = "Docs"
  index_pages = [
    "index",
    "terminal",
  ]
}

network "local" {
  subnet = "10.0.0.0/16"
}
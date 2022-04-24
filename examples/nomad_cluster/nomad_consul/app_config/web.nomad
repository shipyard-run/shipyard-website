job "web" {
  datacenters = ["dc1"]
  type        = "service"

  group "apps" {
    count = 1

    network {
      mode = "bridge"

      port "http" {
        to     = 19090
        static = 19090
      }
    }

    restart {
      # The number of attempts to run the job within the specified interval.
      attempts = 2
      interval = "30m"
      delay    = "15s"
      mode     = "fail"
    }

    ephemeral_disk {
      size = 30
    }

    service {
      name = "web"
      port = "19090"

      connect {
        sidecar_service {
          proxy {
            upstreams {
              destination_name = "api"
              local_bind_port  = 19091
            }
          }
        }
      }
    }

    task "fake_service" {
      # The "driver" parameter specifies the task driver that should be used to
      # run the task.
      driver = "docker"

      logs {
        max_files     = 2
        max_file_size = 10
      }

      env {
        LISTEN_ADDR   = ":19090"
        NAME          = "WEB"
        UPSTREAM_URIS = "http://localhost:19091"
      }

      config {
        image = "nicholasjackson/fake-service:v0.18.1"

        ports = ["http"]
      }

      resources {
        cpu    = 500 # 500 MHz
        memory = 256 # 256MB

      }
    }
  }
}
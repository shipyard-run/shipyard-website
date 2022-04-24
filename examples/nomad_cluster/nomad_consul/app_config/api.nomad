job "api" {
  datacenters = ["dc1"]
  type        = "service"

  group "apps" {
    count = 1

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
      name = "api"
      port = "19090"

      connect {
        sidecar_service {
        }
      }
    }

    network {
      mode = "bridge"

      port "http" {}
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
        LISTEN_ADDR = ":19090"
        NAME        = "API"
      }

      config {
        image = "nicholasjackson/fake-service:v0.22.7"
      }

      resources {
        cpu    = 500 # 500 MHz
        memory = 256 # 256MB
      }
    }
  }
}

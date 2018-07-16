job "jalgoarena-judge" {
  datacenters = ["dc1"]

  update {
    max_parallel = 1
    min_healthy_time = "10s"
    healthy_deadline = "3m"
    progress_deadline = "10m"
    auto_revert = false
    canary = 0
  }

  migrate {
    max_parallel = 1
    health_check = "checks"
    min_healthy_time = "10s"
    healthy_deadline = "5m"
  }

  group "judge-docker-1" {
    restart {
      attempts = 2
      interval = "30m"
      delay = "15s"
      mode = "fail"
    }

    ephemeral_disk {
      size = 1000
    }

    task "jalgoarena-judge-1" {
      driver = "docker"

      config {
        image = "jalgoarena/judge:2.3.475"
        network_mode = "host"
      }

      resources {
        cpu    = 1000
        memory = 1500
      }

      env {
        BOOTSTRAP_SERVERS = "localhost:9092,localhost:9093,localhost:9094"
        JAVA_OPTS = "-Xmx1g -Xms512m"
      }

    }
  }

  group "judge-docker-2" {
    restart {
      attempts = 2
      interval = "30m"
      delay = "15s"
      mode = "fail"
    }

    ephemeral_disk {
      size = 1000
    }

    task "jalgoarena-judge-2" {
      driver = "docker"

      config {
        image = "jalgoarena/judge:2.3.475"
        network_mode = "host"
      }

      resources {
        cpu    = 1000
        memory = 1500
      }

      env {
        BOOTSTRAP_SERVERS = "localhost:9092,localhost:9093,localhost:9094"
        JAVA_OPTS = "-Xmx1g -Xms512m"
        PORT = 6001
      }
    }
  }
}
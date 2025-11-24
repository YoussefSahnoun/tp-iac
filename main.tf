terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.1"
    }
  }
  required_version = ">= 1.0.0"
}

provider "docker" {}

# PostgreSQL image
resource "docker_image" "postgres_image" {
  name         = "postgres:latest"
  keep_locally = true
}

# PostgreSQL container
resource "docker_container" "db_container" {
  name  = "tp-db-postgres"
  image = docker_image.postgres_image.image_id

  env = [
    "POSTGRES_USER=${var.db_user}",
    "POSTGRES_PASSWORD=${var.db_password}",
    "POSTGRES_DB=${var.db_name}"
  ]

  ports {
    internal = 5432
    external = 5432
  }
}

# Build the app image from local Dockerfile_app
resource "docker_image" "app_image" {
  name = "tp-web-app:latest"
  build {
    context    = "${path.module}"
    dockerfile = "Dockerfile_app"
  }
}

# App container
resource "docker_container" "app_container" {
  name  = "tp-app-web"
  image = docker_image.app_image.image_id

  depends_on = [
    docker_container.db_container
  ]

  ports {
    internal = 80
    external = var.app_port_external
  }

}

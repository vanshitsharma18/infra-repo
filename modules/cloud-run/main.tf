resource "google_cloud_run_v2_service" "service" {
  name     = var.service_name
  location = var.region

  template {
    service_account = var.service_account_email

    scaling {
      min_instance_count = 0
      max_instance_count = 2
    }

    containers {
      image = var.image

      ports {
        container_port = var.container_port
      }

      resources {
        limits = {
          cpu    = "1"
          memory = "512Mi"
        }
      }
    }
  }

  ingress = "INGRESS_TRAFFIC_ALL"

  deletion_protection = false
}

resource "google_cloud_run_v2_service_iam_member" "public" {
  project  = google_cloud_run_v2_service.service.project
  location = google_cloud_run_v2_service.service.location
  name     = google_cloud_run_v2_service.service.name

  role   = "roles/run.invoker"
  member = "allUsers"
}
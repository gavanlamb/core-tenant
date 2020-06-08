provider "google" {
  project = var.project_id
  region = var.region
}

terraform {
  backend "gcs" {
    credentials = "./key.json"
    prefix  = "terraform/state"
  }
}
resource "google_cloud_run_service" "api" {
  name = var.image_name
  location = var.region

  template {
    spec {
      containers {
        image = "gcr.io/${var.project_id}/${var.image_name}:${var.build_number}"
        resources {
          limits = {
            cpu = "2000m"
            memory = "2048Mi"
          }
        }
        env {
          name = "LOG_LEVEL"
          value = var.log_level
        }
        env {
          name = "APP_ID"
          value = "${var.image_name}-${var.environment}-${var.build_number}"
        }
        env {
          name = "DevicesDatabaseSettings__ConnectionString"
          value = var.database_connection_string
        }
        env {
          name = "NODE_ENV"
          value = var.environment
        }
      }
    }
  }

  traffic {
    percent = 100
    latest_revision = true
  }
}
resource "google_cloud_run_domain_mapping" "domain" {
  location = var.region
  name     = "${var.subdomain}.${var.domain_name}"

  metadata {
    namespace = var.project_id
  }

  spec {
    route_name = google_cloud_run_service.api.name
    force_override = true
  }
}
resource "google_dns_record_set" "record" {
  name = "${google_cloud_run_domain_mapping.domain.name}."
  managed_zone = var.zone_name
  ttl  = 300
  type = "CNAME"
  rrdatas = ["ghs.googlehosted.com."]
}
data "google_iam_policy" "noauth" {
  binding {
    role = "roles/run.invoker"
    members = [
      "allUsers",
    ]
  }
}
resource "google_cloud_run_service_iam_policy" "noauth" {
  location = google_cloud_run_service.api.location
  service = google_cloud_run_service.api.name
  project = google_cloud_run_service.api.project
  policy_data = data.google_iam_policy.noauth.policy_data
}

# Cloud Run Service (equivalent to Azure App Service)
resource "google_cloud_run_service" "main" {
  name     = "${local.name_prefix}-app"
  location = var.region

  template {
    spec {
      containers {
        image = "gcr.io/cloudrun/hello" # Replace with your application image
        ports {
          container_port = var.app_port
        }

        resources {
          limits = {
            cpu    = "1000m"
            memory = "512Mi"
          }
        }

        env {
          name  = "NODE_ENV"
          value = var.environment
        }

        env {
          name  = "PORT"
          value = tostring(var.app_port)
        }

        env {
          name  = "PROJECT_ID"
          value = var.project_id
        }

        env {
          name  = "REGION"
          value = var.region
        }
      }

      service_account_name = google_service_account.cloud_run.email

      container_concurrency = 100
    }

    metadata {
      annotations = {
        "autoscaling.knative.dev/maxScale"        = "10"
        "autoscaling.knative.dev/minScale"        = "0"
        "run.googleapis.com/vpc-access-connector" = google_vpc_access_connector.main.name
        "run.googleapis.com/vpc-access-egress"    = "private-ranges-only"
      }

      labels = merge(local.common_labels, {
        component = "application"
      })
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }

  depends_on = [
    google_project_service.required_apis
  ]
}

# Allow unauthenticated access
resource "google_cloud_run_service_iam_member" "public_access" {
  service  = google_cloud_run_service.main.name
  location = google_cloud_run_service.main.location
  role     = "roles/run.invoker"
  member   = "allUsers"
}

# Service Account for Cloud Run
resource "google_service_account" "cloud_run" {
  account_id   = "${local.name_prefix}-cloud-run"
  display_name = "Cloud Run Service Account"
  description  = "Service account for Cloud Run application"
}

# IAM bindings for Cloud Run service account
resource "google_project_iam_member" "cloud_run_sql_client" {
  project = var.project_id
  role    = "roles/cloudsql.client"
  member  = "serviceAccount:${google_service_account.cloud_run.email}"
}

resource "google_project_iam_member" "cloud_run_secret_accessor" {
  project = var.project_id
  role    = "roles/secretmanager.secretAccessor"
  member  = "serviceAccount:${google_service_account.cloud_run.email}"
}

resource "google_project_iam_member" "cloud_run_storage_object_user" {
  project = var.project_id
  role    = "roles/storage.objectUser"
  member  = "serviceAccount:${google_service_account.cloud_run.email}"
}

resource "google_project_iam_member" "cloud_run_logging_writer" {
  project = var.project_id
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.cloud_run.email}"
}

resource "google_project_iam_member" "cloud_run_monitoring_writer" {
  project = var.project_id
  role    = "roles/monitoring.metricWriter"
  member  = "serviceAccount:${google_service_account.cloud_run.email}"
}

resource "google_project_iam_member" "cloud_run_trace_agent" {
  project = var.project_id
  role    = "roles/cloudtrace.agent"
  member  = "serviceAccount:${google_service_account.cloud_run.email}"
}

# Storage bucket IAM for shared bucket access
resource "google_storage_bucket_iam_member" "cloud_run_shared_bucket" {
  bucket = google_storage_bucket.shared.name
  role   = "roles/storage.objectUser"
  member = "serviceAccount:${google_service_account.cloud_run.email}"
}

resource "google_storage_bucket_iam_member" "cloud_run_app_bucket" {
  bucket = google_storage_bucket.app.name
  role   = "roles/storage.admin"
  member = "serviceAccount:${google_service_account.cloud_run.email}"
}
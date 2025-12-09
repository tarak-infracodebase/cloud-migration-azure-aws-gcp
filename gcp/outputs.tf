output "project_id" {
  description = "GCP Project ID"
  value       = var.project_id
}

output "region" {
  description = "GCP Region"
  value       = var.region
}

output "vpc_network_name" {
  description = "Name of the VPC network"
  value       = google_compute_network.main.name
}

output "vpc_network_id" {
  description = "ID of the VPC network"
  value       = google_compute_network.main.id
}

output "private_subnet_name" {
  description = "Name of the private subnet"
  value       = google_compute_subnetwork.private.name
}

output "vpc_connector_name" {
  description = "Name of the VPC connector"
  value       = google_vpc_access_connector.main.name
}

output "cloud_run_service_name" {
  description = "Name of the Cloud Run service"
  value       = google_cloud_run_service.main.name
}

output "cloud_run_service_url" {
  description = "URL of the Cloud Run service"
  value       = google_cloud_run_service.main.status[0].url
}

output "cloud_run_service_id" {
  description = "ID of the Cloud Run service"
  value       = google_cloud_run_service.main.id
}

output "database_instance_name" {
  description = "Name of the Cloud SQL instance"
  value       = google_sql_database_instance.postgresql.name
}

output "database_connection_name" {
  description = "Connection name of the Cloud SQL instance"
  value       = google_sql_database_instance.postgresql.connection_name
}

output "database_private_ip" {
  description = "Private IP address of the Cloud SQL instance"
  value       = google_sql_database_instance.postgresql.private_ip_address
  sensitive   = true
}

output "gcs_shared_bucket_name" {
  description = "Name of the shared GCS bucket"
  value       = google_storage_bucket.shared.name
}

output "gcs_shared_bucket_url" {
  description = "URL of the shared GCS bucket"
  value       = google_storage_bucket.shared.url
}

output "gcs_app_bucket_name" {
  description = "Name of the application GCS bucket"
  value       = google_storage_bucket.app.name
}

output "gcs_app_bucket_url" {
  description = "URL of the application GCS bucket"
  value       = google_storage_bucket.app.url
}

output "secret_manager_shared_secrets" {
  description = "Names of shared secrets in Secret Manager"
  value = [
    google_secret_manager_secret.shared_database_connection.secret_id,
    google_secret_manager_secret.shared_api_keys.secret_id
  ]
}

output "secret_manager_app_secrets" {
  description = "Names of application secrets in Secret Manager"
  value = [
    google_secret_manager_secret.app_database_credentials.secret_id,
    google_secret_manager_secret.app_jwt_secret.secret_id,
    google_secret_manager_secret.app_encryption_keys.secret_id
  ]
}

output "cloud_run_service_account_email" {
  description = "Email of the Cloud Run service account"
  value       = google_service_account.cloud_run.email
}

output "monitoring_dashboard_url" {
  description = "URL to the Cloud Monitoring dashboard"
  value       = "https://console.cloud.google.com/monitoring/dashboards/custom/${google_monitoring_dashboard.main.id}?project=${var.project_id}"
}

output "uptime_check_id" {
  description = "ID of the uptime check"
  value       = google_monitoring_uptime_check_config.app_uptime.uptime_check_id
}

output "application_url" {
  description = "URL to access the application"
  value       = google_cloud_run_service.main.status[0].url
}
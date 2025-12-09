# Cloud SQL PostgreSQL (equivalent to Azure PostgreSQL Flexible Server)

# Private service connection for Cloud SQL
resource "google_compute_global_address" "private_ip_address" {
  name          = "${local.name_prefix}-private-ip"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.main.id
}

resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = google_compute_network.main.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_address.name]

  depends_on = [google_project_service.required_apis]
}

# Cloud SQL Instance
resource "google_sql_database_instance" "postgresql" {
  name             = "${local.name_prefix}-postgresql"
  database_version = "POSTGRES_16"
  region           = var.region

  settings {
    # Equivalent to Burstable tier in Azure
    tier = "db-f1-micro"

    # Disk configuration
    disk_type    = "PD_SSD"
    disk_size    = 20
    disk_autoresize = true
    disk_autoresize_limit = 100

    # Backup configuration
    backup_configuration {
      enabled                        = true
      start_time                     = "03:00"
      location                      = var.region
      point_in_time_recovery_enabled = true
      backup_retention_settings {
        retained_backups = 7
        retention_unit   = "COUNT"
      }
    }

    # IP configuration - private only
    ip_configuration {
      ipv4_enabled                                  = false
      private_network                              = google_compute_network.main.id
      enable_private_path_for_google_cloud_services = true
    }

    # Availability type
    availability_type = "ZONAL"  # Use "REGIONAL" for high availability

    # Maintenance window
    maintenance_window {
      day          = 7  # Sunday
      hour         = 4
      update_track = "stable"
    }

    # Database flags
    database_flags {
      name  = "log_checkpoints"
      value = "on"
    }

    database_flags {
      name  = "log_connections"
      value = "on"
    }

    database_flags {
      name  = "log_disconnections"
      value = "on"
    }

    database_flags {
      name  = "log_lock_waits"
      value = "on"
    }

    database_flags {
      name  = "log_min_duration_statement"
      value = "1000"  # Log queries taking longer than 1 second
    }

    # User labels
    user_labels = merge(local.common_labels, {
      component = "database"
    })

    # Insights configuration
    insights_config {
      query_insights_enabled  = true
      query_plans_per_minute  = 5
      query_string_length     = 1024
      record_application_tags = false
      record_client_address   = false
    }
  }

  # Deletion protection
  deletion_protection = false  # Set to true for production

  depends_on = [google_service_networking_connection.private_vpc_connection]
}

# Database
resource "google_sql_database" "main" {
  name     = var.database_name
  instance = google_sql_database_instance.postgresql.name
}

# Database user
resource "google_sql_user" "main" {
  name     = var.database_username
  instance = google_sql_database_instance.postgresql.name
  password = random_password.db_password.result
}
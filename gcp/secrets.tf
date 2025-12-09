# Secret Manager (equivalent to Azure Key Vault)
resource "google_secret_manager_secret" "shared_database_connection" {
  secret_id = "${local.name_prefix}-shared-database-connection"

  labels = merge(local.common_labels, {
    purpose = "shared-secrets"
  })

  replication {
    user_managed {
      replicas {
        location = var.region
      }
    }
  }
}

resource "google_secret_manager_secret_version" "shared_database_connection" {
  secret = google_secret_manager_secret.shared_database_connection.id

  secret_data = jsonencode({
    username = var.database_username
    password = random_password.db_password.result
    host     = google_sql_database_instance.postgresql.private_ip_address
    port     = 5432
    database = var.database_name
    connection_string = "postgresql://${var.database_username}:${random_password.db_password.result}@${google_sql_database_instance.postgresql.private_ip_address}:5432/${var.database_name}"
  })
}

resource "google_secret_manager_secret" "shared_api_keys" {
  secret_id = "${local.name_prefix}-shared-api-keys"

  labels = merge(local.common_labels, {
    purpose = "shared-secrets"
  })

  replication {
    user_managed {
      replicas {
        location = var.region
      }
    }
  }
}

resource "google_secret_manager_secret_version" "shared_api_keys" {
  secret = google_secret_manager_secret.shared_api_keys.id

  secret_data = jsonencode({
    example_api_key = "placeholder-key"
    third_party_secret = "placeholder-secret"
  })
}

resource "google_secret_manager_secret" "app_database_credentials" {
  secret_id = "${local.name_prefix}-app-database-credentials"

  labels = merge(local.common_labels, {
    purpose = "app-secrets"
  })

  replication {
    user_managed {
      replicas {
        location = var.region
      }
    }
  }
}

resource "google_secret_manager_secret_version" "app_database_credentials" {
  secret = google_secret_manager_secret.app_database_credentials.id

  secret_data = jsonencode({
    username = var.database_username
    password = random_password.db_password.result
    host     = google_sql_database_instance.postgresql.private_ip_address
    port     = 5432
    database = var.database_name
    connection_string = "postgresql://${var.database_username}:${random_password.db_password.result}@${google_sql_database_instance.postgresql.private_ip_address}:5432/${var.database_name}"
  })
}

resource "google_secret_manager_secret" "app_jwt_secret" {
  secret_id = "${local.name_prefix}-app-jwt-secret"

  labels = merge(local.common_labels, {
    purpose = "app-secrets"
  })

  replication {
    user_managed {
      replicas {
        location = var.region
      }
    }
  }
}

resource "google_secret_manager_secret_version" "app_jwt_secret" {
  secret = google_secret_manager_secret.app_jwt_secret.id

  secret_data = jsonencode({
    jwt_secret = random_password.jwt_secret.result
  })
}

resource "google_secret_manager_secret" "app_encryption_keys" {
  secret_id = "${local.name_prefix}-app-encryption-keys"

  labels = merge(local.common_labels, {
    purpose = "app-secrets"
  })

  replication {
    user_managed {
      replicas {
        location = var.region
      }
    }
  }
}

resource "google_secret_manager_secret_version" "app_encryption_keys" {
  secret = google_secret_manager_secret.app_encryption_keys.id

  secret_data = jsonencode({
    encryption_key = random_password.encryption_key.result
    salt = random_password.salt.result
  })
}

# Additional random secrets
resource "random_password" "jwt_secret" {
  length  = 32
  special = true
}

resource "random_password" "encryption_key" {
  length  = 32
  special = true
}

resource "random_password" "salt" {
  length  = 16
  special = false
}
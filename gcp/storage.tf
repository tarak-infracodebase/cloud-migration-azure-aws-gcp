# Cloud Storage Buckets (equivalent to Azure Storage Accounts)
resource "google_storage_bucket" "shared" {
  name     = "${local.name_prefix}-shared-storage-${random_id.bucket_suffix.hex}"
  location = var.region

  # Security settings
  uniform_bucket_level_access = true
  public_access_prevention    = "enforced"

  # Lifecycle rule
  lifecycle_rule {
    condition {
      age = 90
    }
    action {
      type = "Delete"
    }
  }

  # Versioning
  versioning {
    enabled = true
  }

  # Labels
  labels = merge(local.common_labels, {
    purpose = "shared-storage"
  })
}

resource "google_storage_bucket" "app" {
  name     = "${local.name_prefix}-app-storage-${random_id.bucket_suffix.hex}"
  location = var.region

  # Allow some public access for web app assets
  uniform_bucket_level_access = false
  public_access_prevention    = "inherited"

  # CORS configuration for web app
  cors {
    origin          = ["*"]
    method          = ["GET", "HEAD", "PUT", "POST", "DELETE"]
    response_header = ["*"]
    max_age_seconds = 3600
  }

  # Website configuration if serving static content
  website {
    main_page_suffix = "index.html"
    not_found_page   = "404.html"
  }

  # Versioning
  versioning {
    enabled = true
  }

  # Labels
  labels = merge(local.common_labels, {
    purpose = "application-storage"
  })
}

# Random suffix for globally unique bucket names
resource "random_id" "bucket_suffix" {
  byte_length = 8
}
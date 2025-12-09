# S3 Buckets (equivalent to Azure Storage Accounts)
module "s3_shared" {
  source = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 4.0"

  bucket = "${local.name_prefix}-shared-storage"

  # Prevent accidental deletion
  object_lock_enabled = false

  # Security settings
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  # Versioning
  versioning = {
    enabled = true
  }

  # Server-side encryption
  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
    }
  }

  # Lifecycle configuration
  lifecycle_rule = [
    {
      id     = "delete_old_versions"
      status = "Enabled"

      noncurrent_version_expiration = {
        days = 90
      }
    }
  ]

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-shared-storage"
    Purpose = "SharedStorage"
  })
}

module "s3_app" {
  source = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 4.0"

  bucket = "${local.name_prefix}-app-storage"

  # Security settings
  block_public_acls       = false  # App may need some public access
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false

  # Versioning
  versioning = {
    enabled = true
  }

  # Server-side encryption
  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
    }
  }

  # CORS configuration for web app
  cors_rule = [
    {
      allowed_headers = ["*"]
      allowed_methods = ["GET", "PUT", "POST", "DELETE", "HEAD"]
      allowed_origins = ["*"]
      expose_headers  = ["ETag"]
      max_age_seconds = 3000
    }
  ]

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-app-storage"
    Purpose = "ApplicationStorage"
  })
}
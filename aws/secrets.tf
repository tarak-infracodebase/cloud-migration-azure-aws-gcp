# Secrets Manager (equivalent to Azure Key Vault)
resource "aws_secretsmanager_secret" "shared_database_connection" {
  name        = "${local.name_prefix}/shared/database-connection"
  description = "Shared database connection string"

  tags = merge(local.common_tags, {
    Purpose = "SharedSecrets"
  })
}

resource "aws_secretsmanager_secret_version" "shared_database_connection" {
  secret_id = aws_secretsmanager_secret.shared_database_connection.id
  secret_string = jsonencode({
    username = var.database_username
    password = random_password.db_password.result
    endpoint = aws_db_instance.postgresql.endpoint
    database = var.database_name
  })
}

resource "aws_secretsmanager_secret" "shared_api_keys" {
  name        = "${local.name_prefix}/shared/api-keys"
  description = "Shared API keys and external service credentials"

  tags = merge(local.common_tags, {
    Purpose = "SharedSecrets"
  })
}

resource "aws_secretsmanager_secret_version" "shared_api_keys" {
  secret_id = aws_secretsmanager_secret.shared_api_keys.id
  secret_string = jsonencode({
    example_api_key = "placeholder-key"
    third_party_secret = "placeholder-secret"
  })
}

resource "aws_secretsmanager_secret" "app_database_credentials" {
  name        = "${local.name_prefix}/app/database-credentials"
  description = "Application database credentials"

  tags = merge(local.common_tags, {
    Purpose = "ApplicationSecrets"
  })
}

resource "aws_secretsmanager_secret_version" "app_database_credentials" {
  secret_id = aws_secretsmanager_secret.app_database_credentials.id
  secret_string = jsonencode({
    username = var.database_username
    password = random_password.db_password.result
    host     = aws_db_instance.postgresql.address
    port     = aws_db_instance.postgresql.port
    database = var.database_name
    connection_string = "postgresql://${var.database_username}:${random_password.db_password.result}@${aws_db_instance.postgresql.endpoint}/${var.database_name}"
  })
}

resource "aws_secretsmanager_secret" "app_jwt_secret" {
  name        = "${local.name_prefix}/app/jwt-secret"
  description = "JWT signing secret for application authentication"

  tags = merge(local.common_tags, {
    Purpose = "ApplicationSecrets"
  })
}

resource "aws_secretsmanager_secret_version" "app_jwt_secret" {
  secret_id = aws_secretsmanager_secret.app_jwt_secret.id
  secret_string = jsonencode({
    jwt_secret = random_password.jwt_secret.result
  })
}

resource "aws_secretsmanager_secret" "app_encryption_keys" {
  name        = "${local.name_prefix}/app/encryption-keys"
  description = "Application encryption keys"

  tags = merge(local.common_tags, {
    Purpose = "ApplicationSecrets"
  })
}

resource "aws_secretsmanager_secret_version" "app_encryption_keys" {
  secret_id = aws_secretsmanager_secret.app_encryption_keys.id
  secret_string = jsonencode({
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
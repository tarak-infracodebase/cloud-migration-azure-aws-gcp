output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}

output "vpc_cidr_block" {
  description = "CIDR block of the VPC"
  value       = aws_vpc.main.cidr_block
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "IDs of the private subnets"
  value       = aws_subnet.private[*].id
}

output "database_subnet_ids" {
  description = "IDs of the database subnets"
  value       = aws_subnet.database[*].id
}

output "load_balancer_dns" {
  description = "DNS name of the load balancer"
  value       = aws_lb.app.dns_name
}

output "load_balancer_zone_id" {
  description = "Zone ID of the load balancer"
  value       = aws_lb.app.zone_id
}

output "database_endpoint" {
  description = "RDS instance endpoint"
  value       = aws_db_instance.postgresql.endpoint
  sensitive   = true
}

output "database_port" {
  description = "RDS instance port"
  value       = aws_db_instance.postgresql.port
}

output "ecs_cluster_name" {
  description = "Name of the ECS cluster"
  value       = aws_ecs_cluster.main.name
}

output "ecs_service_name" {
  description = "Name of the ECS service"
  value       = aws_ecs_service.app.name
}

output "s3_shared_bucket_name" {
  description = "Name of the shared S3 bucket"
  value       = module.s3_shared.s3_bucket_id
}

output "s3_app_bucket_name" {
  description = "Name of the application S3 bucket"
  value       = module.s3_app.s3_bucket_id
}

output "secrets_manager_shared_arns" {
  description = "ARNs of shared secrets"
  value = {
    database-connection = aws_secretsmanager_secret.shared_database_connection.arn
    api-keys           = aws_secretsmanager_secret.shared_api_keys.arn
  }
  sensitive = true
}

output "secrets_manager_app_arns" {
  description = "ARNs of application secrets"
  value = {
    database-credentials = aws_secretsmanager_secret.app_database_credentials.arn
    jwt-secret          = aws_secretsmanager_secret.app_jwt_secret.arn
    encryption-keys     = aws_secretsmanager_secret.app_encryption_keys.arn
  }
  sensitive = true
}

output "cloudwatch_log_group_app" {
  description = "Name of the application CloudWatch log group"
  value       = aws_cloudwatch_log_group.app.name
}

output "cloudwatch_dashboard_url" {
  description = "URL to the CloudWatch dashboard"
  value       = "https://${var.aws_region}.console.aws.amazon.com/cloudwatch/home?region=${var.aws_region}#dashboards:name=${aws_cloudwatch_dashboard.main.dashboard_name}"
}

output "application_url" {
  description = "URL to access the application"
  value       = "http://${aws_lb.app.dns_name}"
}
locals {
  name_prefix = "${var.project_name}-${var.environment}"

  common_tags = {
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "Terraform"
  }

  # Subnet CIDR calculations
  private_subnet_cidrs = [
    cidrsubnet(var.vpc_cidr, 8, 1), # 10.0.1.0/24
    cidrsubnet(var.vpc_cidr, 8, 2)  # 10.0.2.0/24
  ]

  public_subnet_cidrs = [
    cidrsubnet(var.vpc_cidr, 8, 101), # 10.0.101.0/24
    cidrsubnet(var.vpc_cidr, 8, 102)  # 10.0.102.0/24
  ]

  database_subnet_cidrs = [
    cidrsubnet(var.vpc_cidr, 8, 201), # 10.0.201.0/24
    cidrsubnet(var.vpc_cidr, 8, 202)  # 10.0.202.0/24
  ]
}
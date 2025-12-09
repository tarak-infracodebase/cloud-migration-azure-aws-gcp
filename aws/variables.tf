variable "aws_region" {
  type        = string
  description = "AWS region for resources"
  default     = "us-east-1"
}

variable "environment" {
  type        = string
  description = "Environment name (dev, staging, prod)"
  default     = "dev"
}

variable "project_name" {
  type        = string
  description = "Name of the project"
  default     = "infracodebase"
}

variable "availability_zones" {
  type        = list(string)
  description = "List of availability zones"
  default     = ["us-east-1a", "us-east-1b"]
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block for VPC"
  default     = "10.0.0.0/16"
}

variable "database_name" {
  type        = string
  description = "Name of the PostgreSQL database"
  default     = "infracodebase"
}

variable "database_username" {
  type        = string
  description = "Master username for the PostgreSQL database"
  default     = "dbadmin"
}

variable "app_name" {
  type        = string
  description = "Application name"
  default     = "infracodebase-app"
}

variable "app_port" {
  type        = number
  description = "Port the application runs on"
  default     = 3000
}

variable "domain_name" {
  type        = string
  description = "Domain name for the application"
  default     = "infracodebase.example.com"
}
variable "project_id" {
  type        = string
  description = "GCP Project ID"
}

variable "region" {
  type        = string
  description = "GCP region for resources"
  default     = "us-central1"
}

variable "zone" {
  type        = string
  description = "GCP zone for resources"
  default     = "us-central1-a"
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
  default     = 8080
}

variable "domain_name" {
  type        = string
  description = "Domain name for the application"
  default     = "infracodebase.example.com"
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block for VPC"
  default     = "10.0.0.0/16"
}
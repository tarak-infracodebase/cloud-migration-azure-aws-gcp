locals {
  name_prefix = "${var.project_name}-${var.environment}"

  common_labels = {
    environment = var.environment
    project     = var.project_name
    managed_by  = "terraform"
  }

  # Network CIDR calculations
  private_subnet_cidr = "10.0.1.0/24"
  public_subnet_cidr  = "10.0.2.0/24"
  db_subnet_cidr      = "10.0.3.0/24"
}
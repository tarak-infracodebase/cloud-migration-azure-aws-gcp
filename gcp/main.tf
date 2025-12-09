# Random password for database
resource "random_password" "db_password" {
  length  = 16
  special = true
}

# Enable required APIs
resource "google_project_service" "required_apis" {
  for_each = toset([
    "compute.googleapis.com",
    "run.googleapis.com",
    "sqladmin.googleapis.com",
    "secretmanager.googleapis.com",
    "monitoring.googleapis.com",
    "logging.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "servicenetworking.googleapis.com",
    "vpcaccess.googleapis.com"
  ])

  project = var.project_id
  service = each.value

  disable_on_destroy = false
}

# VPC Network
resource "google_compute_network" "main" {
  name                    = "${local.name_prefix}-vpc"
  auto_create_subnetworks = false
  routing_mode            = "GLOBAL"

  depends_on = [google_project_service.required_apis]
}

# Subnets
resource "google_compute_subnetwork" "private" {
  name          = "${local.name_prefix}-private-subnet"
  ip_cidr_range = local.private_subnet_cidr
  region        = var.region
  network       = google_compute_network.main.id

  # Enable private Google access for services
  private_ip_google_access = true

  # Secondary ranges for services if needed
  secondary_ip_range {
    range_name    = "services"
    ip_cidr_range = "10.1.0.0/16"
  }

  secondary_ip_range {
    range_name    = "pods"
    ip_cidr_range = "10.2.0.0/16"
  }
}

# Cloud Router for NAT
resource "google_compute_router" "main" {
  name    = "${local.name_prefix}-router"
  region  = var.region
  network = google_compute_network.main.id
}

# NAT Gateway for outbound internet access from private subnet
resource "google_compute_router_nat" "main" {
  name                               = "${local.name_prefix}-nat"
  router                            = google_compute_router.main.name
  region                            = var.region
  nat_ip_allocate_option            = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}

# Firewall rules
resource "google_compute_firewall" "allow_internal" {
  name    = "${local.name_prefix}-allow-internal"
  network = google_compute_network.main.name

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }

  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }

  source_ranges = [var.vpc_cidr]
}

resource "google_compute_firewall" "allow_cloud_run" {
  name    = "${local.name_prefix}-allow-cloud-run"
  network = google_compute_network.main.name

  allow {
    protocol = "tcp"
    ports    = [tostring(var.app_port)]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["cloud-run"]
}

# VPC Connector for Cloud Run to access VPC resources
resource "google_vpc_access_connector" "main" {
  name           = "${local.name_prefix}-connector"
  region         = var.region
  network        = google_compute_network.main.name
  ip_cidr_range  = "10.0.4.0/28"
  max_throughput = 300

  depends_on = [google_project_service.required_apis]
}
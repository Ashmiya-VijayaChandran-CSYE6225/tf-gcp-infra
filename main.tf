provider "google" {
  project = var.project
  region  = var.region
  zone    = var.zone
}

resource "google_compute_network" "vpc_network" {
  count                           = var.count_of_vpcs
  name                            = count.index < 1 ? var.vpc_network_name : "${var.vpc_network_name}-${count.index}"
  auto_create_subnetworks         = false
  routing_mode                    = var.routing_mode
  delete_default_routes_on_create = true
}

resource "google_compute_subnetwork" "app_network" {
  count         = var.count_of_vpcs
  name          = count.index < 1 ? var.webapp_subnetwork_name : "${var.webapp_subnetwork_name}-${count.index}"
  ip_cidr_range = var.webapp_ip_cidr_range
  network       = google_compute_network.vpc_network[count.index].id
}

resource "google_compute_subnetwork" "db_network" {
  count         = var.count_of_vpcs
  name          = count.index < 1 ? var.db_subnetwork_name : "${var.db_subnetwork_name}-${count.index}"
  ip_cidr_range = var.db_ip_cidr_range
  network       = google_compute_network.vpc_network[count.index].id
}

resource "google_compute_route" "compute_route" {
  count            = var.count_of_vpcs
  name             = count.index < 1 ? var.computer_route_name : "${var.computer_route_name}-${count.index}"
  network          = google_compute_network.vpc_network[count.index].id
  dest_range       = var.dest_range
  next_hop_gateway = var.next_hop_gateway
}

data "google_compute_image" "centos-custom-image-google" {
  family  = "custom-image"
  project = var.project
}

resource "google_compute_instance" "vm_instance" {
  name         = "custom-vm-instance"
  machine_type = "n1-standard-1"
  zone         = var.zone
  boot_disk {
    initialize_params {
      image = data.google_compute_image.centos-custom-image-google.self_link
    }
  }
  network_interface {
    network    = "vpc-network"
    subnetwork = "webapp"
  }
}

resource "google_compute_firewall" "allow_http" {
  name    = "allow-http"
  network = "vpc-network"
  allow {
    protocol = "tcp"
    ports    = ["80"]
  }
  source_ranges = ["0.0.0.0/0"]
}
provider "google" {
  project = var.project
  region  = var.region
  zone    = var.zone
}

resource "google_compute_network" "vpc_network" {
  name                            = var.vpc_network_name
  auto_create_subnetworks         = false
  routing_mode                    = var.routing_mode
  delete_default_routes_on_create = true
}

resource "google_compute_subnetwork" "app_network" {
  name          = var.webapp_subnetwork_name
  ip_cidr_range = var.webapp_ip_cidr_range
  network       = google_compute_network.vpc_network.id
}

resource "google_compute_subnetwork" "db_network" {
  name          = var.db_subnetwork_name
  ip_cidr_range = var.db_ip_cidr_range
  network       = google_compute_network.vpc_network.id
}

resource "google_compute_route" "compute_route" {
  name             = var.computer_route_name
  network          = google_compute_network.vpc_network.id
  dest_range       = var.dest_range
  next_hop_gateway = var.next_hop_gateway
}

data "google_compute_image" "centos-custom-image-google" {
  name = var.google_compute_image
  project = var.project
}

resource "google_compute_instance" "vm_instance" {
  name         = var.vm_instance_name
  machine_type = var.vm_machine_type
  zone         = var.zone
  tags         = var.google_compute_instance_tags
  boot_disk {
    device_name = var.vm_device_name
    initialize_params {
      image = data.google_compute_image.centos-custom-image-google.self_link
      size  = var.initialize_params_size
      type  = var.initialize_params_type
    }
  }
  network_interface {
    network    = google_compute_network.vpc_network.self_link
    subnetwork = google_compute_subnetwork.app_network.self_link
    access_config {

    }
  }
  service_account {
    email  = var.service_account_email
    scopes = var.service_account_scopes
  }
}

resource "google_compute_firewall" "google_compute_firewall_deny" {
  name        = var.google_compute_firewall_deny
  network     = google_compute_network.vpc_network.self_link
  description = var.google_compute_firewall_deny_description

  deny {
    protocol = "all"
    ports    = []
  }

  source_tags   = var.source_tags
  target_tags   = var.target_tags
  source_ranges = var.source_ranges
}

resource "google_compute_firewall" "google_compute_firewall_allow" {
  name        = var.google_compute_firewall_allow
  network     = google_compute_network.vpc_network.self_link
  description = var.google_compute_firewall_allow_description

  allow {
    protocol = "tcp"
    ports    = var.ports
  }
  priority = 100
  source_tags   = var.source_tags
  target_tags   = var.target_tags
  source_ranges = var.source_ranges
}
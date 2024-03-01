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
  name                     = var.db_subnetwork_name
  ip_cidr_range            = var.db_ip_cidr_range
  private_ip_google_access = true
  network                  = google_compute_network.vpc_network.id
}

resource "google_compute_route" "compute_route" {
  name             = var.computer_route_name
  network          = google_compute_network.vpc_network.id
  dest_range       = var.dest_range
  next_hop_gateway = var.next_hop_gateway
}

data "google_compute_image" "centos-custom-image-google" {
  name    = var.google_compute_image
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
  metadata_startup_script = <<-EOF
    echo "DATABASE_URL=jdbc:mysql://${google_sql_database_instance.mysql_db_instance.private_ip_address}:3306/webapp?createDatabaseIfNotExist=true" > .env
    echo "DATABASE_USERNAME=webapp" >> .env
    echo "DATABASE_PASSWORD=${random_password.password.result}" >> .env
    sudo mv .env /opt/
    sudo chown csye6225:csye6225 /opt/.env
    sudo setenforce 0
    sudo systemctl daemon-reload
    sudo systemctl restart start-webapp.service
  EOF
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
  priority      = 100
  source_tags   = var.source_tags
  target_tags   = var.target_tags
  source_ranges = var.source_ranges
}

resource "google_compute_global_address" "global_address" {
  name          = var.global_address_name
  address_type  = var.address_type
  purpose       = var.address_purpose
  network       = google_compute_network.vpc_network.self_link
  prefix_length = var.prefix_length
}

resource "google_service_networking_connection" "networking_connection" {
  network                 = google_compute_network.vpc_network.self_link
  service                 = var.networking_connection_service
  reserved_peering_ranges = [google_compute_global_address.global_address.name]
}

resource "random_id" "db_name_suffix" {
  byte_length = 4
}
resource "google_sql_database_instance" "mysql_db_instance" {
  name                = "mysql-instance-${random_id.db_name_suffix.hex}"
  database_version    = var.db_version
  deletion_protection = var.deletion_protection
  depends_on          = [google_service_networking_connection.networking_connection]
  settings {
    tier              = var.settings_tier
    availability_type = var.availability_type
    disk_type         = var.disk_type
    disk_size         = var.disk_size
    backup_configuration {
      enabled            = var.backup_enabled
      binary_log_enabled = var.binary_log_enabled
    }
    ip_configuration {
      ipv4_enabled                                  = var.ipv4_enabled
      private_network                               = google_compute_network.vpc_network.self_link
      enable_private_path_for_google_cloud_services = var.enable_private_path_for_google_cloud_services
      # require_ssl = true
      # authorized_networks {
      #   name  = google_compute_instance.vm_instance.name
      #   value = google_compute_instance.vm_instance.network_interface[0].access_config[0].nat_ip
      # }
      # = [google_compute_subnetwork.app_network.self_link]
    }
  }
}
resource "google_sql_database" "db" {
  name     = var.sql_db_name
  instance = google_sql_database_instance.mysql_db_instance.name
}

resource "random_password" "password" {
  length           = var.password_length
  special          = var.password_special
  min_lower        = var.password_min_lower
  min_upper        = var.password_min_upper
  min_numeric      = var.password_min_numeric
  min_special      = var.password_min_special
  override_special = var.override_special
}


resource "google_sql_user" "users" {
  name     = var.sql_user
  instance = google_sql_database_instance.mysql_db_instance.name
  password = random_password.password.result
}
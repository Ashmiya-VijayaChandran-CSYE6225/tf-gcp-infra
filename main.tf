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

# resource "google_compute_instance" "vm_instance" {
#   name         = var.vm_instance_name
#   machine_type = var.vm_machine_type
#   zone         = var.zone
#   tags         = var.google_compute_instance_tags
#   boot_disk {
#     device_name = var.vm_device_name
#     initialize_params {
#       image = data.google_compute_image.centos-custom-image-google.self_link
#       size  = var.initialize_params_size
#       type  = var.initialize_params_type
#     }
#   }
#   network_interface {
#     network    = google_compute_network.vpc_network.self_link
#     subnetwork = google_compute_subnetwork.app_network.self_link
#     access_config {

#     }
#   }
#   service_account {
#     email  = google_service_account.service_account.email
#     scopes = var.service_account_scopes
#   }
#   metadata_startup_script = <<-EOF
#     echo "DATABASE_URL=jdbc:mysql://${google_sql_database_instance.mysql_db_instance.private_ip_address}:3306/${var.database_name}?createDatabaseIfNotExist=true" > .env
#     echo "DATABASE_USERNAME=${google_sql_user.users.name}" >> .env
#     echo "DATABASE_PASSWORD=${google_sql_user.users.password}" >> .env
#     sudo mv .env /opt/
#     sudo chown csye6225:csye6225 /opt/.env
#     sudo setenforce 0
#     sudo systemctl daemon-reload
#     sudo systemctl restart start-webapp.service
#   EOF
# }

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
  name       = var.sql_user
  instance   = google_sql_database_instance.mysql_db_instance.name
  password   = random_password.password.result
  depends_on = [google_sql_database_instance.mysql_db_instance]
}

resource "google_service_account" "service_account" {
  account_id   = var.service_account_id
  display_name = var.service_account_display_name
}

resource "google_project_iam_binding" "service_account_roles" {
  project = var.project
  for_each = toset([
    var.role_logging_admin,
    var.role_monitoring_metric_writer,
    var.role_pubsub_publisher
  ])
  role = each.key

  members = [
    "serviceAccount:${google_service_account.service_account.email}"
  ]
}

resource "google_pubsub_topic" "verify_email" {
  name                       = var.pubsub_topic
  message_retention_duration = var.message_retention_duration
}

resource "random_id" "bucket_random_id" {
  byte_length = 8
}

resource "google_storage_bucket" "bucket" {
  name                        = "${random_id.bucket_random_id.hex}-gcf-source"
  location                    = "US"
  uniform_bucket_level_access = true
}


resource "google_storage_bucket_object" "verify_email" {
  name   = var.bucket_object_name
  bucket = google_storage_bucket.bucket.name
  source = var.bucket_object_source
}

resource "google_vpc_access_connector" "vpc_access_connector" {
  name          = var.vpc_access_connector
  ip_cidr_range = var.vpc_access_connector_ip_cidr_range
  network       = google_compute_network.vpc_network.self_link
}

resource "google_pubsub_subscription" "subcription" {
  name                       = var.subscription
  topic                      = google_pubsub_topic.verify_email.id
  message_retention_duration = var.subcription_message_retention_duration
  retain_acked_messages      = var.retain_acked_messages
  ack_deadline_seconds       = var.ack_deadline_seconds
}

resource "google_cloudfunctions2_function" "verify_cloud_function" {
  name        = var.verify_cloud_function_name
  description = var.verify_cloud_function_description
  location    = var.region

  build_config {
    runtime     = var.verify_cloud_function_build_config
    entry_point = var.verify_cloud_function_entry_point

    source {
      storage_source {
        bucket = google_storage_bucket.bucket.name
        object = google_storage_bucket_object.verify_email.name
      }
    }

  }
  service_config {
    service_account_email         = google_service_account.service_account.email
    vpc_connector                 = google_vpc_access_connector.vpc_access_connector.id
    vpc_connector_egress_settings = var.vpc_connector_egress_settings
    environment_variables = {
      DATABASE_NAME     = var.sql_db_name
      DATABASE_USERNAME = var.sql_user
      DATABASE_PASSWORD = random_password.password.result
      DATABASE_URL      = "jdbc:mysql://${google_sql_database_instance.mysql_db_instance.private_ip_address}:3306/${var.database_name}"
    }
  }

  event_trigger {
    trigger_region = var.region
    event_type     = var.event_type
    pubsub_topic   = google_pubsub_topic.verify_email.id
    retry_policy   = var.retry_policy
  }
}

resource "google_compute_region_instance_template" "region_instance_template" {
  name = var.region_instance_template

  tags = var.google_compute_instance_tags

  machine_type = var.vm_machine_type
  depends_on   = [google_service_account.service_account, google_project_iam_binding.service_account_roles]
  // Create a new boot disk from an image
  disk {
    source_image = var.google_compute_image
    auto_delete  = true
    boot         = true
    disk_size_gb = var.initialize_params_size
    disk_type    = var.initialize_params_type
  }

  network_interface {
    network    = google_compute_network.vpc_network.self_link
    subnetwork = google_compute_subnetwork.app_network.self_link
    access_config {

    }
  }

  metadata_startup_script = <<-EOF
    echo "DATABASE_URL=jdbc:mysql://${google_sql_database_instance.mysql_db_instance.private_ip_address}:3306/${var.database_name}?createDatabaseIfNotExist=true" > .env
    echo "DATABASE_USERNAME=${google_sql_user.users.name}" >> .env
    echo "DATABASE_PASSWORD=${google_sql_user.users.password}" >> .env
    sudo mv .env /opt/
    sudo chown csye6225:csye6225 /opt/.env
    sudo setenforce 0
    sudo systemctl daemon-reload
    sudo systemctl restart start-webapp.service
  EOF

  service_account {
    email  = google_service_account.service_account.email
    scopes = var.service_account_scopes
  }
}

resource "google_compute_health_check" "autohealing" {
  name                = var.compute_health_check
  check_interval_sec  = var.check_interval_sec
  timeout_sec         = var.timeout_sec
  healthy_threshold   = var.healthy_threshold
  unhealthy_threshold = var.unhealthy_threshold

  http_health_check {
    request_path = var.request_path
    port         = var.request_path_port
  }
}

resource "google_compute_region_autoscaler" "region_autoscaler" {
  name   = var.region_autoscaler
  region = var.region
  target = google_compute_region_instance_group_manager.webapp_server.id

  autoscaling_policy {
    max_replicas    = var.max_replicas
    min_replicas    = var.min_replicas
    cooldown_period = var.cooldown_period

    cpu_utilization {
      target = var.cpu_utilization
    }
  }
}
resource "google_compute_region_instance_group_manager" "webapp_server" {
  name = var.instance_group_manager

  base_instance_name = var.vm_instance_name
  region             = var.region

  version {
    instance_template = google_compute_region_instance_template.region_instance_template.self_link
  }
  named_port {
    name = var.named_port
    port = var.named_port_number
  }

  auto_healing_policies {
    health_check      = google_compute_health_check.autohealing.id
    initial_delay_sec = var.initial_delay_sec
  }
}


resource "google_compute_managed_ssl_certificate" "loadbalancer_certificate" {
  name = var.ssl_certificate

  managed {
    domains = var.ssl_certificate_domains
  }
}
resource "google_compute_backend_service" "default" {
  name                  = var.backend_service
  health_checks         = [google_compute_health_check.autohealing.id]
  load_balancing_scheme = var.load_balancing_scheme
  port_name             = var.load_balancing_scheme_port_name
  protocol              = var.load_balancing_scheme_protocol
  log_config {
    enable = true
  }
  backend {
    group = google_compute_region_instance_group_manager.webapp_server.instance_group
  }
}
resource "google_compute_url_map" "default" {
  name            = var.url_map
  default_service = google_compute_backend_service.default.id
}
resource "google_compute_target_https_proxy" "loadbalancer_default" {
  name    = var.https_proxy
  url_map = google_compute_url_map.default.id
  ssl_certificates = [
    google_compute_ssl_certificate.nc_ssl_certificate.id
  ]
  depends_on = [
    google_compute_ssl_certificate.nc_ssl_certificate
  ]
}

resource "google_compute_global_forwarding_rule" "default" {
  ip_protocol           = "TCP"
  name                  = var.global_forwarding_rule
  target                = google_compute_target_https_proxy.loadbalancer_default.id
  port_range            = var.global_forwarding_rule_port_range
  load_balancing_scheme = var.global_forwarding_rule_load_balancing_scheme
}

resource "google_compute_ssl_certificate" "nc_ssl_certificate" {
  name        = var.nc_ssl_certificate
  private_key = file(var.nc_ssl_certificate_private_key)
  certificate = file(var.nc_ssl_certificate_certificate)
}

resource "google_dns_record_set" "dns_record_set" {
  name = var.dns_record_name
  type = var.dns_record_type
  ttl  = var.dns_record_ttl

  managed_zone = var.dns_record_managed_zone
  rrdatas      = [google_compute_global_forwarding_rule.default.ip_address]
  # rrdatas      = [google_compute_instance.vm_instance.network_interface[0].access_config[0].nat_ip]
}
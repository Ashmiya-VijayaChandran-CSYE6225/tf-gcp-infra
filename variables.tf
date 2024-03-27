variable "project" {
  description = "ID of the GCP Project"
  type        = string
}

variable "region" {
  description = "Region for deployment"
  type        = string
}

variable "zone" {
  description = "Zone for deployment"
  type        = string
}

variable "vpc_network_name" {
  description = "Name of the VPC Network"
  type        = string
}

variable "routing_mode" {
  description = "Routing Mode"
  type        = string
}

variable "webapp_subnetwork_name" {
  description = "Webapp Subnetwork Name"
  type        = string
}

variable "webapp_ip_cidr_range" {
  description = "IP CIDR range for Webapp subnet"
  type        = string
}

variable "db_subnetwork_name" {
  description = "DB Subnetwork Name"
  type        = string
}

variable "db_ip_cidr_range" {
  description = "IP CIDR range for DB subnet"
  type        = string
}

variable "computer_route_name" {
  description = "Computer Route Name"
  type        = string
}

variable "dest_range" {
  description = "Destination Range for the route to the computer"
  type        = string
}

variable "next_hop_gateway" {
  description = "The next hop gateway for the route to the computer"
  type        = string
}

variable "service_account_email" {
  description = "Service Account Email"
  type        = string
}

variable "google_compute_image" {
  description = "Google Compute Image"
  type        = string
}

variable "vm_instance_name" {
  description = "VM Instance name"
  type        = string
}

variable "vm_machine_type" {
  description = "VM Machine Type"
  type        = string
}

variable "vm_device_name" {
  description = "VM Device Name"
  type        = string
}

variable "initialize_params_type" {
  description = "Initialize Params Type"
  type        = string
}

variable "initialize_params_size" {
  description = "Initialize Params Size"
  type        = number
}

variable "google_compute_instance_tags" {
  description = "Google Compute Instance Tags"
  type        = list(string)
}

variable "service_account_scopes" {
  description = "Service Account Scopes"
  type        = list(string)
}

variable "google_compute_firewall_deny" {
  description = "Firewall Deny"
  type        = string
}

variable "google_compute_firewall_allow" {
  description = "Firewall Allow"
  type        = string
}

variable "google_compute_firewall_deny_description" {
  description = "Firewall Deny Description"
  type        = string
}

variable "google_compute_firewall_allow_description" {
  description = "Firewall Allow Description"
  type        = string
}

variable "source_tags" {
  description = "Source Tags"
  type        = list(string)
}

variable "target_tags" {
  description = "Target Tags"
  type        = list(string)
}

variable "source_ranges" {
  description = "Source Ranges"
  type        = list(string)
}

variable "ports" {
  description = "Ports"
  type        = list(string)
}

variable "global_address_name" {
  description = "Global Address Name"
  type        = string
}

variable "address_type" {
  description = "Address Type"
  type        = string
}

variable "address_purpose" {
  description = "Address Purpose"
  type        = string
}

variable "prefix_length" {
  description = "Prefix Length"
  type        = number
}

variable "networking_connection_service" {
  description = "Networking Connection Service"
  type        = string
}

variable "db_version" {
  description = "DB Version"
  type        = string
}

variable "deletion_protection" {
  description = "Deletion Protection"
  type        = bool
  default     = false
}

variable "settings_tier" {
  description = "Settings Tier"
  type        = string
}

variable "availability_type" {
  description = "Availability Type"
  type        = string
  default     = "REGIONAL"
}

variable "disk_type" {
  description = "Disk Type"
  type        = string
  default     = "PD_SSD"
}

variable "disk_size" {
  description = "Disk Size"
  type        = number
  default     = 100
}

variable "backup_enabled" {
  description = "Backup Enabled"
  type        = bool
}

variable "binary_log_enabled" {
  description = "Binary Log Enabled"
  type        = bool
}

variable "ipv4_enabled" {
  description = "IPV4 Enabled"
  type        = bool
  default     = false
}

variable "enable_private_path_for_google_cloud_services" {
  description = "IPV4 Enabled"
  type        = bool
}

variable "sql_db_name" {
  description = "SQL DB Name"
  type        = string
}

variable "sql_user" {
  description = "SQL User"
  type        = string
}

variable "password_length" {
  description = "Password Length"
  type        = number
}

variable "password_min_lower" {
  description = "Password Length"
  type        = number
}

variable "password_min_upper" {
  description = "Password Length"
  type        = number
}

variable "password_min_numeric" {
  description = "Password Length"
  type        = number
}

variable "password_min_special" {
  description = "Password Length"
  type        = number
}

variable "override_special" {
  description = "Override Special"
  type        = string
}

variable "password_special" {
  description = "Password Special"
  type        = bool
}

variable "database_name" {
  description = "Database Name"
  type        = string
}

variable "dns_record_name" {
  description = "DNS Record Name"
  type        = string
}

variable "dns_record_type" {
  description = "DNS Record Type"
  type        = string
}

variable "dns_record_ttl" {
  description = "DNS Record TTL"
  type        = number
}

variable "dns_record_managed_zone" {
  description = "DNS Managed Zone"
  type        = string
}

variable "service_account_id" {
  description = "Service Account ID"
  type        = string
}

variable "service_account_display_name" {
  description = "Service Account Display Name"
  type        = string
}

variable "role_logging_admin" {
  description = "Logging Admin Role"
  type        = string
}

variable "role_monitoring_metric_writer" {
  description = "Monitoring Metric Writer"
  type        = string
}

variable "role_pubsub_publisher" {
  description = "Pub/Sub Publisher"
  type        = string
}

variable "pubsub_topic" {
  description = "Pub/Sub Topic"
  type        = string
}

variable "message_retention_duration" {
  description = "Message Retention Duration"
  type        = string
}

variable "bucket_object_name" {
  description = "Bucket Object Name"
  type        = string
}

variable "bucket_object_source" {
  description = "Bucket Object Source"
  type        = string
}

variable "verify_cloud_function_name" {
  description = "Verify Cloud Function Name"
  type        = string
}

variable "verify_cloud_function_description" {
  description = "Verify Cloud Function Description"
  type        = string
}

variable "verify_cloud_function_build_config" {
  description = "Verify Cloud Function Build Config"
  type        = string
}

variable "verify_cloud_function_entry_point" {
  description = "Verify Cloud Function Entry Point"
  type        = string
}

variable "event_type" {
  description = "Event Type"
  type        = string
}

variable "retry_policy" {
  description = "Retry Policy"
  type        = string
}

variable "vpc_connector_egress_settings" {
  description = "Egress Settings"
  type        = string
}

variable "subscription" {
  description = "Subscription"
  type        = string
}

variable "subcription_message_retention_duration" {
  description = "Subscription Message Retention Duration"
  type        = string
}

variable "ack_deadline_seconds" {
  description = "ack_deadline_seconds"
  type        = number
}

variable "retain_acked_messages" {
  description = "retain_acked_messages"
  type        = bool
}

variable "vpc_access_connector" {
  description = "vpc_access_connector"
  type        = string
}

variable "vpc_access_connector_ip_cidr_range" {
  description = "vpc_access_connector_ip_cidr_range"
  type        = string
}
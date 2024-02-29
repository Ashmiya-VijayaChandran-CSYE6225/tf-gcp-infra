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
  type = string
}

variable "deletion_protection" {
  description = "Deletion Protection"
  type = bool
  default = false
}

variable "settings_tier" {
  description = "Settings Tier"
  type = string
}

variable "availability_type" {
  description = "Availability Type"
  type = string
}

variable "disk_type" {
  description = "Disk Type"
  type = string
}

variable "disk_size" {
  description = "Disk Size"
  type = number
}

variable "backup_enabled" {
  description = "Backup Enabled"
  type = bool
}

variable "binary_log_enabled" {
  description = "Binary Log Enabled"
  type = bool
}

variable "ipv4_enabled" {
  description = "IPV4 Enabled"
  type = bool
}

variable "enable_private_path_for_google_cloud_services" {
  description = "IPV4 Enabled"
  type = bool
}

variable "sql_db_name" {
  description = "SQL DB Name"
  type = string
}

variable "sql_user" {
  description = "SQL User"
  type = string
}

variable "password_length" {
  description = "Password Length"
  type = number
}

variable "password_min_lower" {
  description = "Password Length"
  type = number
}

variable "password_min_upper" {
  description = "Password Length"
  type = number
}

variable "password_min_numeric" {
  description = "Password Length"
  type = number
}

variable "password_min_special" {
  description = "Password Length"
  type = number
}

variable "override_special" {
  description = "Override Special"
  type = string
}

variable "password_special" {
  description = "Password Special"
  type = bool
}
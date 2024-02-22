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
  type = list(string)
}

variable "target_tags" {
  description = "Target Tags"
  type = list(string)
}

variable "source_ranges" {
  description = "Source Ranges"
  type = list(string)
}

variable "ports" {
  description = "Ports"
  type = list(string)
}
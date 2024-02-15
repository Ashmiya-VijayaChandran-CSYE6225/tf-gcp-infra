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

variable "count_of_vpcs" {
  description = "Count of VPCs to create"
  type        = number
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
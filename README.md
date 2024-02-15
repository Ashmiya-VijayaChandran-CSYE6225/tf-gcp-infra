# tf-gcp-infra

## Prerequisites

- Install Google Cloud SDK
- Install Terraform

## Local Setup

- git clone - to clone the tf-gcp-infra repository
- add Google Cloud SDK to environment variables path
- gcloud auth login - to authenticate with GCP
  
## Terraform commands

- terraform init - to initialize the Terraform provider
- terraform plan - to generate execution plan
- terraform apply - to apply the Terraform configuration
- terraform destroy - to destroy all the resources configured
- terraform fmt - to format the configuration files

## Terraform Files

- variables.tf - configured the variables in this file
- main.tf - defined the networking resources such as VPC, subnets and routes

## Enabled APIs for GCP

- Compute Engine
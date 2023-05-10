# GCP variables
variable "gcp_project_id" {
  description = "Google Cloud Platform (GCP) Project ID."
  type        = string
}

variable "zone1" {
  description = "GCP zone name."
  type        = string
}

variable "region1" {
  description = "GCP region name."
  type        = string
}

variable "machine_type" {
  description = "GCP VM instance machine type."
  type        = string
}

variable "snyk_broker_token" {
  description = "Snyk Broker Token"
  type	      = string
}

variable "bitbucket_username" {
  description = "Bitbucket username"
  type        = string
}

variable "bitbucket_password" {
  description = "Bitbucket password"
  type        = string
}

variable "my_subnet" {
  description = "Source IP address for GCP firewall"
  type        = string
}

# Cloudflare Variables
variable "cloudflare_zone" {
  description = "The Cloudflare Zone to use."
  type        = string
}

variable "cloudflare_zone_id" {
  description = "The Cloudflare UUID for the Zone to use."
  type        = string
}

variable "cloudflare_account_id" {
  description = "The Cloudflare UUID for the Account the Zone lives in."
  type        = string
}

variable "cloudflare_email" {
  description = "The Cloudflare user."
  type        = string
}

variable "cloudflare_token" {
  description = "The Cloudflare user's API token."
  type        = string
}

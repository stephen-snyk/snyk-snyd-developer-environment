# Here is where we tell terraform which providers we want to use
provider "google" {
  project = var.gcp_project_id
}

terraform {
  required_providers {
    cloudflare = {
      source = "cloudflare/cloudflare"
       version = "4.5.0"
    }
  }
}
provider "cloudflare" {
#  email = var.cloudflare_email
  api_token = var.cloudflare_token
}

provider "random" {
}

resource "random_id" "argo_secret" {
  byte_length = 35
}

resource "cloudflare_tunnel" "snyk_dev_desktop" {
  account_id = var.cloudflare_account_id
  name       = "snyk_dev_desktop"
  secret     = random_id.argo_secret.b64_std
}

resource "cloudflare_tunnel_config" "snyk_dev_desktop_config" {
  account_id = var.cloudflare_account_id
  tunnel_id = cloudflare_tunnel.snyk_dev_desktop.id

  config {
    warp_routing {
      enabled = true
    }
    ingress_rule {
      hostname = "vncweb"
      service = "tcp://localhost:5901"
    }
    ingress_rule {
      hostname = "student1"
      service = "tcp://localhost:5903"
    }
    ingress_rule {
      hostname = "student2"
      service = "tcp://localhost:5904"
    }
    ingress_rule {
      hostname = "student3"
      service = "tcp://localhost:5905"
    }
    ingress_rule {
      hostname = "student4"
      service = "tcp://localhost:5906"
    }
    ingress_rule {
      hostname = "student5"
      service = "tcp://localhost:5907"
    }
    ingress_rule {
      hostname = "student6"
      service = "tcp://localhost:5908"
    }
    ingress_rule {
      hostname = "student7"
      service = "tcp://localhost:5909"
    }
    ingress_rule {
      service  = "http_status:404"
    }
  }
}

resource "cloudflare_record" "vncweb" {
  zone_id = var.cloudflare_zone_id
  name    = "vncweb"
  value   = "${cloudflare_tunnel.snyk_dev_desktop.id}.cfargotunnel.com"
  type    = "CNAME"
  proxied = true
}

# Creates an Access application to control who can connect.
resource "cloudflare_access_application" "snyk_dev_desktop" {
  zone_id          = var.cloudflare_zone_id
  name             = "Access application for http_app.${var.cloudflare_zone}"
  domain           = "vncweb.${var.cloudflare_zone}"
  session_duration = "1h"
}

# Creates an Access policy for the application.
resource "cloudflare_access_policy" "vnc_policy" {
  application_id = cloudflare_access_application.http_app.id
  zone_id        = var.cloudflare_zone_id
  name           = "Example policy for vncweb.${var.cloudflare_zone}"
  precedence     = "1"
  decision       = "allow"
  include {
    email = [var.cloudflare_email]
  }
}

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
      service  = "http_status:404"
    }
  }
}

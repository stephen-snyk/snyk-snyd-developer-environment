resource "cloudflare_record" "vncweb" {
  zone_id = var.cloudflare_zone_id
  name    = "vncweb"
  value   = "${cloudflare_tunnel.snyk_dev_desktop.id}.cfargotunnel.com"
  type    = "CNAME"
  proxied = true
}

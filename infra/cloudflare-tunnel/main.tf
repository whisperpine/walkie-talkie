terraform {
  required_version = ">= 1.10"
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5.7.0"
    }
  }
}

# cloudflare_zero_trust_tunnel_cloudflared resource docs:
# https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/zero_trust_tunnel_cloudflared
resource "cloudflare_zero_trust_tunnel_cloudflared" "default" {
  account_id = var.cloudflare_account_id
  name       = var.cloudflare_tunnel_name
}

# cloudflare_zero_trust_tunnel_cloudflared_token data docs:
# https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/data-sources/zero_trust_tunnel_cloudflared
data "cloudflare_zero_trust_tunnel_cloudflared_token" "default" {
  account_id = var.cloudflare_account_id
  tunnel_id  = cloudflare_zero_trust_tunnel_cloudflared.default.id
}

# cloudflare_dns_record resource docs:
# https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/dns_record
resource "cloudflare_dns_record" "wtws" {
  zone_id = var.cloudflare_zone_id
  name    = var.dns_record_prefix_wtws
  content = "${cloudflare_zero_trust_tunnel_cloudflared.default.id}.cfargotunnel.com"
  comment = "walkie-talkie's websocket api endpoint"
  type    = "CNAME"
  proxied = true
  ttl     = 1 # setting to 1 means automatic
}

# cloudflare_dns_record resource docs:
# https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/dns_record
resource "cloudflare_dns_record" "wtapi" {
  zone_id = var.cloudflare_zone_id
  name    = var.dns_record_prefix_wtapi
  content = "${cloudflare_zero_trust_tunnel_cloudflared.default.id}.cfargotunnel.com"
  comment = "walkie-talkie's REST api endpoint"
  type    = "CNAME"
  proxied = true
  ttl     = 1 # setting to 1 means automatic
}

# cloudflare_zero_trust_tunnel_cloudflared_config docs:
# https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/zero_trust_tunnel_cloudflared_config
resource "cloudflare_zero_trust_tunnel_cloudflared_config" "default" {
  tunnel_id  = cloudflare_zero_trust_tunnel_cloudflared.default.id
  account_id = var.cloudflare_account_id
  config = {
    ingress = [
      {
        hostname = "${cloudflare_dns_record.wtws.name}.${var.cloudflare_zone}"
        service  = "ws://wt-websocket:3000"
        origin_request = {
          no_tls_verify = true
        }
      },
      {
        hostname = "${cloudflare_dns_record.wtapi.name}.${var.cloudflare_zone}"
        service  = "http://wt-rest-api:8080"
        origin_request = {
          no_tls_verify = true
        }
      },
      # The last ingress rule must match all URLs.
      # (i.e. it should not have a hostname or path filter)
      {
        service = "http_status:404"
      },
    ]
  }
}

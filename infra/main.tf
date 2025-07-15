# Generates a 64-character secret for the tunnel.
# Using `random_password` means the result is treated as sensitive and, thus,
# not displayed in console output. Refer to: https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password
resource "random_password" "tunnel_secret" {
  length = 64
}

# sops_file data docs:
# https://registry.terraform.io/providers/carlpett/sops/latest/docs/data-sources/file
data "sops_file" "default" {
  source_file = "encrypted.tfvars.json"
}

locals {
  # Cloudflare API token created at https://dash.cloudflare.com/profile/api-tokens
  cloudflare_token = data.sops_file.default.data["cloudflare_token"]
  # Zone is the domain (e.g. example.com)
  cloudflare_zone = data.sops_file.default.data["cloudflare_zone"]
  # Zone ID for your domain
  cloudflare_zone_id = data.sops_file.default.data["cloudflare_zone_id"]
  # Account ID for your Cloudflare account
  cloudflare_account_id = data.sops_file.default.data["cloudflare_account_id"]
  # The name of cloudflare tunnel
  cloudflare_tunnel_name = data.sops_file.default.data["cloudflare_tunnel_name"]
  # The dns record prefix for websocket api
  dns_record_prefix_wtws = data.sops_file.default.data["dns_record_prefix_wtws"]
  # The dns record prefix for REST api
  dns_record_prefix_wtapi = data.sops_file.default.data["dns_record_prefix_wtapi"]
}

# cloudflare_zero_trust_tunnel_cloudflared resource docs:
# https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/zero_trust_tunnel_cloudflared
resource "cloudflare_zero_trust_tunnel_cloudflared" "default" {
  account_id = local.cloudflare_account_id
  name       = local.cloudflare_tunnel_name
}

# cloudflare_zero_trust_tunnel_cloudflared_token data docs:
# https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/data-sources/zero_trust_tunnel_cloudflared
data "cloudflare_zero_trust_tunnel_cloudflared_token" "default" {
  account_id = local.cloudflare_account_id
  tunnel_id  = cloudflare_zero_trust_tunnel_cloudflared.default.id
}

# cloudflare_dns_record resource docs:
# https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/dns_record
resource "cloudflare_dns_record" "wtws" {
  zone_id = local.cloudflare_zone_id
  name    = local.dns_record_prefix_wtws
  content = "${cloudflare_zero_trust_tunnel_cloudflared.default.id}.cfargotunnel.com"
  comment = "walkie-talkie's websocket api endpoint"
  type    = "CNAME"
  proxied = true
  ttl     = 1 # setting to 1 means automatic
}

# cloudflare_dns_record resource docs:
# https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/dns_record
resource "cloudflare_dns_record" "wtapi" {
  zone_id = local.cloudflare_zone_id
  name    = local.dns_record_prefix_wtapi
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
  account_id = local.cloudflare_account_id
  config = {
    ingress = [
      {
        hostname = "${cloudflare_dns_record.wtws.name}.${local.cloudflare_zone}"
        service  = "ws://wt-websocket:3000"
        origin_request = {
          no_tls_verify = true
        }
      },
      {
        hostname = "${cloudflare_dns_record.wtapi.name}.${local.cloudflare_zone}"
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

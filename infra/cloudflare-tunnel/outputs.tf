output "tunnel_token" {
  value     = data.cloudflare_zero_trust_tunnel_cloudflared_token.default.token
  sensitive = true
}

output "tunnel_dns_records" {
  description = "The DNS records of published application routes"
  value = [
    cloudflare_dns_record.wtws.name,
    cloudflare_dns_record.wtapi.name
  ]
  sensitive = true
}

output "tunnel_token" {
  description = "the token used by Cloudflare Tunnel"
  value       = module.cloudflare_tunnel.tunnel_token
  sensitive   = true
}

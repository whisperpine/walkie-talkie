variable "cloudflare_token" {
  description = "Cloudflare API token created at https://dash.cloudflare.com/profile/api-tokens"
  type        = string
  sensitive   = true
}

variable "cloudflare_zone" {
  description = "Zone is the domain (e.g. example.com)"
  type        = string
}

variable "cloudflare_zone_id" {
  description = "Zone ID for your domain"
  type        = string
}

variable "cloudflare_account_id" {
  description = "Account ID for your Cloudflare account"
  type        = string
  sensitive   = true
}

variable "cloudflare_tunnel_name" {
  description = "The name of cloudflare tunnel"
  type        = string
}

variable "dns_record_prefix_wtws" {
  description = "The dns record prefix for websocket api"
  type        = string
}

variable "dns_record_prefix_wtapi" {
  description = "The dns record prefix for REST api"
  type        = string
}

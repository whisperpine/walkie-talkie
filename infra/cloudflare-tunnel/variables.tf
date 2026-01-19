variable "cloudflare_zone" {
  description = "Zone is the domain (e.g. example.com)"
  type        = string
}

variable "cloudflare_zone_id" {
  description = "Zone ID for your domain"
  type        = string
  validation {
    condition     = length(var.cloudflare_zone_id) == 32
    error_message = "it must be a string with 32 characters"
  }
  validation {
    condition     = can(regex("^[0-9a-f]+$", var.cloudflare_zone_id))
    error_message = "every character must be a valid hexadecimal number"
  }
}

variable "cloudflare_account_id" {
  description = "Account ID for your Cloudflare account"
  type        = string
  sensitive   = true
  validation {
    condition     = length(var.cloudflare_account_id) == 32
    error_message = "it must be a string with 32 characters"
  }
  validation {
    condition     = can(regex("^[0-9a-f]+$", var.cloudflare_account_id))
    error_message = "every character must be a valid hexadecimal number"
  }
}

variable "cloudflare_tunnel_name" {
  description = "The name of cloudflare tunnel"
  type        = string
  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.cloudflare_tunnel_name))
    error_message = "it must contain only lowercase letters, numbers, and hyphens"
  }
}

variable "dns_record_prefix_wtws" {
  description = "The dns record prefix for websocket api"
  type        = string
  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.dns_record_prefix_wtws))
    error_message = "it must contain only lowercase letters, numbers, and hyphens"
  }
}

variable "dns_record_prefix_wtapi" {
  description = "The dns record prefix for REST api"
  type        = string
  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.dns_record_prefix_wtapi))
    error_message = "it must contain only lowercase letters, numbers, and hyphens"
  }
}

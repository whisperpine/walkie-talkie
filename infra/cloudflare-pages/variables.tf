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

variable "pages_project_name" {
  description = "Cloudflare Pages project name"
  type        = string
  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.pages_project_name))
    error_message = "it must contain only lowercase letters, numbers, and hyphens"
  }
}

variable "pages_custom_domain" {
  default = "Cloudflare Pages project's custom domain"
  type    = string
}

variable "pages_production_branch" {
  description = "Cloudflare Pages project's production branch"
  default     = "main"
  type        = string
}

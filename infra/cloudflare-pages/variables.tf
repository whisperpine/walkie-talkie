variable "cloudflare_zone_id" {
  description = "Zone ID for your domain"
  type        = string
}

variable "cloudflare_account_id" {
  description = "Account ID for your Cloudflare account"
  type        = string
  sensitive   = true
}

variable "pages_project_name" {
  description = "Cloudflare Pages project name"
  type        = string
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

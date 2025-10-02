terraform {
  required_version = ">= 1.10"
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5.11.0"
    }
  }
}

# Create a Cloudflare Pages project
resource "cloudflare_pages_project" "default" {
  name              = var.pages_project_name
  account_id        = var.cloudflare_account_id
  production_branch = var.pages_production_branch
}

# Create a CNAME record to point the custom domain to the Pages project
resource "cloudflare_dns_record" "default" {
  zone_id = var.cloudflare_zone_id
  name    = var.pages_custom_domain
  content = cloudflare_pages_project.default.subdomain
  comment = "walkie-talkie's frontend webapp"
  type    = "CNAME"
  proxied = true
  ttl     = 1 # setting to 1 means automatic
}

# Associate the custom domain with the Pages project
resource "cloudflare_pages_domain" "default" {
  name         = var.pages_custom_domain
  account_id   = var.cloudflare_account_id
  project_name = cloudflare_pages_project.default.name
}

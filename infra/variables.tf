variable "cloudflare_r2_bucket_name" {
  description = "The name of Cloudflare R2 bucket which stores terraform state"
  default     = "tf-states"
  type        = string
}

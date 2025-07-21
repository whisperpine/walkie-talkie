# Infrastructure as Code

Setup Cloudflare Tunnel by
[Terraform](https://github.com/hashicorp/terraform)
or [OpenTofu](https://github.com/opentofu/opentofu)
(which can be used interchangeably at the moment).

## Terraform Modules

- [cloudflare-pages](./cloudflare-pages/README.md):
  Create a Cloudflare Pages project and add a custom domain.
- [cloudflare-tunnel](./cloudflare-tunnel/README.md):
  Create a Cloudflare Tunnel and add correlated DNS records.

## Terraform Remote Backend

[Terraform S3 backend](https://developer.hashicorp.com/terraform/language/backend/s3)
is used in this repo (the actual backend is Cloudflare R2 which is
S3-compatibal). Hence a Cloudflare R2 bucket should be created beforehand, as
well as an API Token with write permission to the bucket.
Refer to [Remote R2 backend - Cloudflare Docs](https://developers.cloudflare.com/terraform/advanced-topics/remote-backend/).

The credentials of the API Token shouldn't be configured directly in the
[./providers.tf](./providers.tf) for security considerations. Instead use
environment variable: `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`
(both locally and in CI).

## SOPS Encryption

The input variables of root module are stored in [./encrypted.default.json](./encrypted.default.json)
encrypted by [sops](https://github.com/getsops/sops) using [age](https://github.com/FiloSottile/age).
The file naming should follow `encrypted.${terraform.workspace}.json` for different
[Workspaces](https://opentofu.org/docs/language/state/workspaces/).

Terraform Provider [carlpett/sops](https://registry.terraform.io/providers/carlpett/sops/latest)
can read values from sops-encrypted files automatically if credentials are
accessible and correct. For example, in CI/CD pipelines, provide age private key
by `SOPS_AGE_KEY`:

```yaml
# GitHub Actions Workflow.
env:
  SOPS_AGE_KEY: ${{ secrets.SOPS_AGE_KEY }}
```

## Terraform Outputs

Read the descriptions in [./outputs.tf](./outputs.tf)
to learn how to use each output.

```sh
cd INFRA_DIR
# List all outputs with value masked by <sensitive>.
tofu output 
# Get the value by their explicit names. For example:
tofu output tunnel_token
```

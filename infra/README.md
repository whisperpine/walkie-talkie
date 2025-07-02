# README

Setup Cloudflare Tunnel by OpenTofu.

## Prerequisites

- A domain hosted by Cloudflare DNS.
- An organization on Cloudflare Zero Trust.
- [OpenTofu](https://opentofu.org/) (the `tofu` command) is installed.

## Get Started

- Create an API Token with [proper permissions](#api-token).
- Configure variables in `terraform.tfvars` file (create if missing).
- Run the following commands:

```sh
cd INFRA_DIR
tofu init
tofu apply -auto-approve
```

## API Token

API Token minimal permissions:

| Permission type | Permission | Access level |
| - | - | - |
| Account | Cloudflare Tunnel | Edit |
| Account | Access: Apps and Policies | Edit |
| Zone | DNS | Edit |

## Tunnel Token

Run the following command to get tunnel token:

```sh
cd INFRA_DIR
tofu output tunnel_token
```

Tunnel Token should be assigned to `CLOUDFLARED_TOKEN` in `.env` file.

## References

- [Cloudflare Terraform - Cloudflare Docs](https://developers.cloudflare.com/terraform/).
- [Deploy Tunnels with Terraform - Cloudflare Docs](https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/deployment-guides/terraform/).
- [Cloudflare Provider - Terraform Registry](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs).

# Cloudflare Tunnel Module

Create a Cloudflare Tunnel and add correlated DNS records.

## Prerequisites

- A domain hosted by Cloudflare DNS (so that DNS records could be managed
  by terraform).
- An organization on Cloudflare Zero Trust (in order to configure Cloudflare Tunnel).
- Create an API Token with proper permissions (see [API Token](#api-token) below).

## API Token

API Token minimal permissions:

| Permission type | Permission | Access level |
| - | - | - |
| Account | Cloudflare Tunnel | Edit |
| Account | Access: Apps and Policies | Edit |
| Zone | DNS | Edit |

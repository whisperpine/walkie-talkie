# Cloudflare Pages Module

Create a Cloudflare Pages project and add a custom domain.

## Prerequisites

- A domain hosted by Cloudflare DNS (so that DNS records could be managed
  by terraform).
- Create an API Token with proper permissions (see [API Token](#api-token) below).

## API Token

API Token minimal permissions:

| Permission type | Permission | Access level |
| - | - | - |
| Account | Cloudflare Pages | Edit |
| Zone | DNS | Edit |

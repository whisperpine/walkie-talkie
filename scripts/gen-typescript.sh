#!/bin/sh

# Purpose: generate typescript client sdk
# Usage: sh path/to/gen-typescript.sh
# Dependencies: redocly, openapi-generator-cli
# Date: 2025-07-03
# Author: Yusong

set -e

# Bundle OpenAPI Specifications in to a single file.
redocly bundle \
  -o ./openapi/bundled.yaml \
  ./openapi/openapi.yaml

package_name="wt-webapp-sdk"
output_dir="./$package_name"

# Generate server stubs with rust-axum generator.
openapi-generator-cli generate \
  --package-name $package_name \
  --output $output_dir \
  --config ./openapi/ts.oasgen.yaml

## Learn more about "openapi-generator-cli generate" command.
# openapi-generator-cli help generate

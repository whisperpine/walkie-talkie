# ======================================
# OpenAPI
# ======================================

# lint OpenAPI Specifications
lint:
  redocly lint ./openapi/openapi.yaml

# generate API documentation as an HTML file
doc:
  sh ./scripts/build-docs.sh

# run OpenAPI contract tests by Arazzo
arazzo:
  # generate test workflows from the openapi spec
  redocly generate-arazzo ./openapi/openapi.yaml -o gen.arazzo.yaml
  # run contract tests against the api server
  redocly respect gen.arazzo.yaml --verbose

# generate server stubs with rust-axum generator
gen-axum:
  sh ./scripts/gen-rust-axum.sh

# generate typescript client sdk
gen-ts:
  sh ./scripts/gen-typescript.sh

# ======================================
# Frontend
# ======================================

# run frontend wt-webapp in debug mode
front:
  bun run --cwd wt-webapp dev

# build frontend wt-webapp and preview
preview:
  bun run --cwd wt-webapp build
  bun run --cwd wt-webapp preview


# ======================================
# Backend
# ======================================

# run backend wt-websocket in debug mode
websocket:
  RUST_LOG="wt_websocket=debug" \
  cargo run -p wt-websocket

# run backend wt-rest-api in debug mode
rest-api:
  RUST_LOG="wt_rest_api=debug" \
  cargo run -p wt-rest-api

# build the docker image for wt-websocket
build-wt:
  docker build \
    -t wt-websocket \
    -f ./wtws.Dockerfile \
        .

# build the docker image for wt-rest-api
build-api:
  docker build \
    -t wt-rest-api \
    -f ./wtapi.Dockerfile \
    .


# ======================================
# Deployment
# ======================================

# spin up the services, make it publicly available
spinup:
  docker compose \
    --file ./prod.compose.yaml \
    up -d

# spin down the services, make it publicly unavailable
spindown:
  docker compose \
    --file ./prod.compose.yaml \
    down

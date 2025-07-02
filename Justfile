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
run:
    RUST_LOG=debug \
    cargo run -p wt-websocket

# build the docker image for the local machine's platform
build:
    docker build \
        -t wt-websocket \
        -f ./wtws.Dockerfile \
        .

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
    cargo run -p wt-websocket

# build the docker image for the local machine's platform
build:
    docker build \
        -t wt-websocket \
        -f ./wtws.Dockerfile \
        .

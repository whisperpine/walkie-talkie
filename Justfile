# run frontend wt-webapp in debug mode
front:
    bun run --cwd wt-webapp dev

# run backend wt-websocket in debug mode
run:
    cargo run -p wt-websocket

# build the docker image for the local machine's platform
build:
    docker build \
        -t wt-websocket \
        -f ./wtws.Dockerfile \
        .

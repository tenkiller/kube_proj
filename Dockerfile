# The version of Alpine to use for the final image
# This should match the version of Alpine that the `elixir:1.8-alpine` image uses
ARG ALPINE_VERSION=3.9

FROM elixir:1.8-alpine AS builder

ARG APP_NAME=kube_proj
ARG MIX_ENV=prod

# These should be specified at build time by the CLI
ARG VERSION=0.0.0

WORKDIR /usr/local/sifi/${APP_NAME}

# This step installs all the build tools we'll need
RUN apk update && \
    apk upgrade --no-cache && \
    apk add --no-cache nodejs nodejs-npm && \
    mix local.rebar --force && \
    mix local.hex --force

# Copies our app source code into the build container
COPY . .

# Compile Elixir
RUN mix do deps.get, deps.compile, compile

# Compile Javascript
RUN cd assets \
    && npm install \
    && ./node_modules/webpack/bin/webpack.js --mode production \
    && cd .. \
    && mix phx.digest

# Run Distillery
RUN mkdir -p /opt/release \
    && mix release --verbose \
    && mv _build/${MIX_ENV}/rel/${APP_NAME} /opt/release

# Create the runtime container
FROM alpine:${ALPINE_VERSION} as runtime

# Set default ARGs
ARG APP_NAME=kube_proj
ARG PORT=4000

# Install runtime dependencies
RUN apk update && \
    apk add --no-cache bash openssl-dev

WORKDIR /usr/local/sifi/${APP_NAME}

COPY --from=builder /opt/release/${APP_NAME} .

RUN cd bin && ln -s ${APP_NAME} app

CMD [ "bin/app", "foreground" ]

# HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=2 \
#  CMD nc -vz -w 2 localhost 4000 || exit 1

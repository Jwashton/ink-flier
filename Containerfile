################
#     Base     #
################

FROM docker.io/elixir:1.17-alpine AS base

# Install system dependencies
RUN apk update \
  && apk upgrade \
  && apk add \
  # PostgreSQL client for Database access
  postgresql-client \
  # PID 1 reaping
  tini \
  # Timezone data
  tzdata



################
# Development  #
################
FROM base AS dev

# Install system dependencies & common dev tools
RUN apk update \
  && apk upgrade \
  && apk add \
  # Node.js for compiling front-end assets
  nodejs-current \
  npm \
  # Git for version control
  git \
  # Shellcheck for linting shell scripts
  shellcheck \
  # inotify-tools for file watching
  inotify-tools \
  # Common utilities
  bash \
  curl \
  gnupg \
  ripgrep \
  vim \
  # Timezone data
  tzdata \
  # Windows Compatibility
  su-exec

# Set up non-root user
RUN adduser -D -g '' -s bash developer
USER developer
WORKDIR /srv
RUN git config --global --add safe.directory /srv

COPY --chown=developer ./scripts/bash_theme_snippet.sh /home/developer/.bashrc

# Install Phoenix
RUN mix local.hex --force \
  && mix archive.install hex phx_new --force

# For Windows compatibility, switch to root user for entrypoint
USER root

# Set up entrypoint
COPY --chown=developer ./scripts/entrypoint.sh /home/developer/entrypoint.sh

ENTRYPOINT [ "/home/developer/entrypoint.sh" ]

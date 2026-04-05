# syntax = docker/dockerfile:1
#
# Fullstack Demo — Production Container
# Target: GCP Cloud Run (works with any container platform)
#
# Architecture:
#   Multi-stage build → Ruby 3.3 + Node 22 build stage, slim runtime stage
#   All assets (Vite JS/CSS bundles) are compiled inside the image
#   SQLite for demo (swap for Postgres/MySQL in production)
#
# Build:
#   docker build -t fullstack-demo .
#
# Run:
#   docker run -p 3000:3000 fullstack-demo
#
# Cloud Run deploy:
#   gcloud run deploy fullstack-demo \
#     --source . \
#     --region us-central1 \
#     --allow-unauthenticated

ARG RUBY_VERSION=3.3.0
ARG NODE_VERSION=22

# ╔══════════════════════════════════════════════════════════════╗
# ║  Stage 1: Base — slim Ruby runtime (no build tools)        ║
# ╚══════════════════════════════════════════════════════════════╝
FROM docker.io/library/ruby:${RUBY_VERSION}-slim AS base

WORKDIR /rails

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
      curl libjemalloc2 libvips sqlite3 && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development:test" \
    RAILS_LOG_TO_STDOUT="1" \
    RAILS_SERVE_STATIC_FILES="1"

# ╔══════════════════════════════════════════════════════════════╗
# ║  Stage 2: Build — gems, Node modules, Vite asset pipeline  ║
# ╚══════════════════════════════════════════════════════════════╝
FROM base AS build

ARG NODE_VERSION

# Install build tools + Node.js
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
      build-essential git libyaml-dev pkg-config && \
    curl -fsSL https://deb.nodesource.com/setup_${NODE_VERSION}.x | bash - && \
    apt-get install --no-install-recommends -y nodejs && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Ruby gems
COPY Gemfile Gemfile.lock ./
RUN bundle install && \
    rm -rf ~/.bundle/ \
           "${BUNDLE_PATH}"/ruby/*/cache \
           "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
    bundle exec bootsnap precompile --gemfile

# Node packages
COPY package.json package-lock.json ./
RUN npm install

# Application code
COPY . .

# Bootsnap precompile
RUN bundle exec bootsnap precompile app/ lib/

# Vite build: compiles React JSX, Tailwind CSS, and Hotwire JS
# SECRET_KEY_BASE_DUMMY lets Rails boot without real credentials
RUN SECRET_KEY_BASE_DUMMY=1 ./bin/rails assets:precompile

# ╔══════════════════════════════════════════════════════════════╗
# ║  Stage 3: Runtime — slim image with compiled artifacts     ║
# ╚══════════════════════════════════════════════════════════════╝
FROM base

COPY --from=build "${BUNDLE_PATH}" "${BUNDLE_PATH}"
COPY --from=build /rails /rails

# Non-root user (Cloud Run best practice)
RUN groupadd --system --gid 1000 rails && \
    useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash && \
    chown -R rails:rails db log storage tmp public
USER 1000:1000

ENTRYPOINT ["/rails/bin/docker-entrypoint"]

# Cloud Run injects PORT; default 3000
ENV PORT=3000
EXPOSE 3000

CMD ["sh", "-c", "./bin/rails server -b 0.0.0.0 -p ${PORT}"]

# SPDX-License-Identifier: MPL-2.0
# SPDX-FileCopyrightText: 2026 Jonathan D.A. Jewell (hyperpolymath) <j.d.a.jewell@open.ac.uk>
#
# Project tasks plus the estate provisioning contract in build/just/provision.just.
mod provision 'build/just/provision.just'

set shell := ["bash", "-euo", "pipefail", "-c"]

# Show available project and provisioning tasks.
default:
    @just --list

# Provision every supported tool and dependency, then diagnose the environment.
setup: provision::setup

doctor: provision::doctor

# Apply safe automatic fixes and repeat doctor.
heal: provision::heal

dev-shell: provision::dev-shell

toolchain-refresh: provision::toolchain-refresh

ai-setup: provision::ai-setup
ai-warmup who="user": (provision::ai-warmup who)
config-show: provision::config-show
langs: provision::langs

build: provision::build
test: provision::test
bench: provision::bench
lint: provision::lint check-no-a2ml
fmt: provision::fmt
fmt-check: provision::fmt-check
run: provision::run
deps: provision::deps
eval: provision::eval

# Compile the allowlisted Pages site with Bun.
site-build:
    bun run scripts/build-site.mjs --config site.json

# Test site CLI handling, allowlisted files, generated links, and base URLs with Bun.
site-test:
    bun test

# Build the allowlisted site twice and compare the complete outputs.
site-check:
    sh scripts/check-site-reproducible.sh

# Enforce the current RSR retirement of A2ML metadata files.
check-no-a2ml:
    bash scripts/check-no-a2ml.sh

# Run a deterministic analytics example; no API server or database is required.
demo:
    ./scripts/demo.sh

# Optional local database services; the source code does not connect to them yet.
db-up:
    podman compose up -d

db-down:
    podman compose down

db-logs SERVICE="":
    if [ -n "{{SERVICE}}" ]; then podman compose logs -f "{{SERVICE}}"; else podman compose logs -f; fi

# Build the optional WASM target (requires rustup and its wasm32 target).
wasm-build:
    rustup target add wasm32-unknown-unknown
    cargo build --locked --release --target wasm32-unknown-unknown

# Julia's package test suite is part of `just test` through provision::test.
julia-test:
    julia --project=. -e 'using Pkg; Pkg.test()'

# Check the canonical provisioning set without mutating it.
provision-check:
    bash build/just/provision-check.sh

# Run the local gates used before submitting changes.
validate: doctor fmt-check lint test site-check

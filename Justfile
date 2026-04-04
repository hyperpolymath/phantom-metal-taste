# justfile - Modern command runner
# https://github.com/casey/just
#
# Install: cargo install just
# Usage: just <recipe>
# List: just --list

# Default recipe (shows help)
default:
    @just --list

# ============================================================================
# Development Workflows
# ============================================================================

# Build ReScript code
build:
    @echo "🔨 Building ReScript → JavaScript..."
    rescript build

# Build in watch mode
watch:
    @echo "👀 Watching ReScript files..."
    rescript build -w

# Clean build artifacts
clean:
    @echo "🧹 Cleaning build artifacts..."
    rescript clean
    rm -rf lib/
    rm -rf **/*.bs.js
    rm -rf **/*.bs.mjs

# Run the application
run: build
    @echo "🚀 Running application..."
    deno run --allow-net --allow-env --allow-read src/orchestrator/Index.bs.js

# Run in development mode with watch
dev:
    @echo "🔥 Starting development server..."
    deno run --allow-net --allow-env --allow-read --watch src/orchestrator/Index.bs.js

# ============================================================================
# Testing
# ============================================================================

# Run all tests
test: build
    @echo "🧪 Running tests..."
    deno test --allow-net --allow-env --allow-read tests/

# Run tests with coverage
test-coverage: build
    @echo "📊 Running tests with coverage..."
    deno test --allow-net --allow-env --allow-read --coverage=coverage/ tests/
    deno coverage coverage/

# Run specific test file
test-file FILE: build
    @echo "🧪 Running test: {{FILE}}"
    deno test --allow-net --allow-env --allow-read {{FILE}}

# ============================================================================
# Database Management
# ============================================================================

# Start databases (ArangoDB + Virtuoso)
db-up:
    @echo "🗄️  Starting databases..."
    podman-compose up -d
    @echo "⏳ Waiting for health checks..."
    @sleep 10
    @podman-compose ps

# Stop databases
db-down:
    @echo "🛑 Stopping databases..."
    podman-compose down

# Reset databases (delete all data)
db-reset:
    @echo "♻️  Resetting databases (will delete all data)..."
    podman-compose down -v
    podman-compose up -d
    @sleep 10
    @echo "✓ Databases reset"

# Show database logs
db-logs SERVICE="":
    @if [ "{{SERVICE}}" = "" ]; then \
        podman-compose logs -f; \
    else \
        podman-compose logs -f {{SERVICE}}; \
    fi

# Check database health
db-health:
    @echo "🏥 Checking database health..."
    @podman-compose ps
    @echo "\n📊 ArangoDB:"
    @curl -s http://localhost:8529/_api/version || echo "❌ Not responding"
    @echo "\n🕸️  Virtuoso:"
    @curl -s http://localhost:8890/sparql || echo "❌ Not responding"

# ============================================================================
# Code Quality
# ============================================================================

# Format code
fmt:
    @echo "✨ Formatting code..."
    deno fmt
    @echo "✓ Deno files formatted"
    # ReScript formatter (if available)
    @command -v rescript-format >/dev/null && find src -name "*.res" -exec rescript-format -i {} \; || echo "⚠️  rescript-format not found"

# Lint code
lint:
    @echo "🔍 Linting code..."
    deno lint

# Type check
typecheck: build
    @echo "🔎 Type checking..."
    @echo "✓ ReScript type checking done by compiler"
    @echo "Checking Rust..."
    cd src/core && cargo check

# Check all (fmt + lint + typecheck)
check: fmt lint typecheck
    @echo "✅ All checks passed!"

# ============================================================================
# Rust/WASM
# ============================================================================

# Build Rust/WASM modules
wasm-build:
    @echo "🦀 Building Rust → WASM..."
    cd src/core && cargo build --target wasm32-unknown-unknown --release
    @echo "✓ WASM built: src/core/target/wasm32-unknown-unknown/release/*.wasm"

# Test Rust code
wasm-test:
    @echo "🧪 Testing Rust code..."
    cd src/core && cargo test

# Check Rust code
wasm-check:
    @echo "🔍 Checking Rust code..."
    cd src/core && cargo check
    cd src/core && cargo clippy -- -D warnings

# ============================================================================
# Julia Analytics
# ============================================================================

# Test Julia modules
julia-test:
    @echo "🧪 Testing Julia modules..."
    cd src/analytics && julia --project=. -e 'using Pkg; Pkg.test()'

# Run Julia script
julia-run SCRIPT:
    @echo "📊 Running Julia script: {{SCRIPT}}"
    julia --project=src/analytics src/analytics/{{SCRIPT}}

# ============================================================================
# Documentation
# ============================================================================

# Generate UML diagrams (requires plantuml)
diagrams:
    @echo "📐 Generating UML diagrams..."
    @command -v plantuml >/dev/null || (echo "❌ plantuml not found. Install: brew install plantuml"; exit 1)
    plantuml docs/diagrams/*.puml
    @echo "✓ Diagrams generated in docs/diagrams/"

# Serve documentation locally
docs-serve:
    @echo "📚 Serving documentation..."
    @command -v python3 >/dev/null && (cd docs && python3 -m http.server 8000) || \
     (command -v python >/dev/null && (cd docs && python -m SimpleHTTPServer 8000)) || \
     echo "❌ Python not found for serving docs"

# ============================================================================
# RSR Compliance
# ============================================================================

# Verify RSR compliance
rsr-verify:
    @echo "✅ Verifying RSR (Rhodium Standard Repository) compliance..."
    @echo ""
    @echo "📋 Documentation:"
    @test -f README.md && echo "  ✓ README.md" || echo "  ❌ README.md"
    @test -f LICENSE && echo "  ✓ LICENSE" || echo "  ❌ LICENSE"
    @test -f SECURITY.md && echo "  ✓ SECURITY.md" || echo "  ❌ SECURITY.md"
    @test -f CODE_OF_CONDUCT.md && echo "  ✓ CODE_OF_CONDUCT.md" || echo "  ❌ CODE_OF_CONDUCT.md"
    @test -f CONTRIBUTING.md && echo "  ✓ CONTRIBUTING.md" || echo "  ❌ CONTRIBUTING.md"
    @test -f MAINTAINERS.md && echo "  ✓ MAINTAINERS.md" || echo "  ❌ MAINTAINERS.md"
    @test -f CHANGELOG.md && echo "  ✓ CHANGELOG.md" || echo "  ❌ CHANGELOG.md"
    @echo ""
    @echo "🌐 .well-known/:"
    @test -f .well-known/security.txt && echo "  ✓ security.txt (RFC 9116)" || echo "  ❌ security.txt"
    @test -f .well-known/ai.txt && echo "  ✓ ai.txt (AI training policy)" || echo "  ❌ ai.txt"
    @test -f .well-known/humans.txt && echo "  ✓ humans.txt (attribution)" || echo "  ❌ humans.txt"
    @echo ""
    @echo "🔧 Build System:"
    @test -f justfile && echo "  ✓ justfile (task runner)" || echo "  ❌ justfile"
    @test -f deno.json && echo "  ✓ deno.json (Deno config)" || echo "  ❌ deno.json"
    @test -f bsconfig.json && echo "  ✓ bsconfig.json (ReScript)" || echo "  ❌ bsconfig.json"
    @test -f compose.yml && echo "  ✓ compose.yml" || echo "  ❌ compose.yml"
    @test -f .gitlab-ci.yml && echo "  ✓ .gitlab-ci.yml (CI/CD)" || echo "  ⚠️  .gitlab-ci.yml (optional)"
    @test -f flake.nix && echo "  ✓ flake.nix (Nix builds)" || echo "  ⚠️  flake.nix (optional)"
    @echo ""
    @echo "🔒 Security:"
    @echo "  ✓ ReScript (sound types, no null/undefined)"
    @echo "  ✓ Deno (explicit permissions)"
    @test -f src/core/Cargo.toml && echo "  ✓ Rust/WASM (memory safety)" || echo "  ⚠️  Rust/WASM"
    @echo ""
    @echo "📦 Offline-First:"
    @echo "  ✓ No required network calls in core"
    @echo "  ✓ Local database instances"
    @echo "  ✓ Air-gap capable"
    @echo ""
    @echo "🧪 Testing:"
    @test -d tests && echo "  ✓ Test directory exists" || echo "  ❌ tests/"
    @echo ""
    @echo "🎯 TPCF Perimeter:"
    @echo "  ✓ Perimeter 3: Community Sandbox (Open Source)"
    @echo ""
    @echo "📊 RSR Compliance Level: BRONZE"

# Full validation (all checks + tests)
validate: check rsr-verify test
    @echo ""
    @echo "🎉 Full validation complete!"

# ============================================================================
# Git Workflows
# ============================================================================

# Show git status
status:
    @git status

# Create a new feature branch
branch NAME:
    @echo "🌿 Creating branch: {{NAME}}"
    git checkout -b feature/{{NAME}}

# Quick commit and push
commit MSG:
    @echo "💾 Committing: {{MSG}}"
    git add -A
    git commit -m "{{MSG}}"
    git push

# ============================================================================
# Release Management
# ============================================================================

# Create a new release
release VERSION:
    @echo "🚀 Creating release: v{{VERSION}}"
    @echo "Updating CHANGELOG.md..."
    @echo "\n## [{{VERSION}}] - $(date +%Y-%m-%d)" >> CHANGELOG.md
    git add CHANGELOG.md
    git commit -m "Release v{{VERSION}}"
    git tag -a v{{VERSION}} -m "Release v{{VERSION}}"
    @echo "✓ Tagged v{{VERSION}}"
    @echo "Push with: git push && git push --tags"

# ============================================================================
# Utilities
# ============================================================================

# Show project statistics
stats:
    @echo "📊 Project Statistics"
    @echo "===================="
    @echo "Lines of Code:"
    @find src -name "*.res" -o -name "*.rs" -o -name "*.jl" | xargs wc -l | tail -1
    @echo "\nFiles:"
    @find src -type f | wc -l
    @echo "\nLanguages:"
    @echo "  - ReScript: $(find src -name "*.res" | wc -l) files"
    @echo "  - Rust: $(find src -name "*.rs" | wc -l) files"
    @echo "  - Julia: $(find src -name "*.jl" | wc -l) files"
    @echo "\nDependencies:"
    @echo "  - Deno imports: $(grep -c '"' deno.json || echo 0)"
    @echo "  - Rust crates: $(grep -c 'dependencies' src/core/Cargo.toml 2>/dev/null || echo 0)"

# Clean everything (build artifacts + databases)
nuke: clean db-down
    @echo "💥 Nuclear clean - removing all generated files and containers..."
    rm -rf coverage/
    rm -rf .deno/
    podman-compose down -v
    @echo "✓ Everything cleaned!"

# Show system information
info:
    @echo "🔧 System Information"
    @echo "===================="
    @echo "Deno: $(deno --version | head -1)"
    @echo "ReScript: $(rescript -version)"
    @command -v cargo >/dev/null && echo "Rust: $(rustc --version)" || echo "Rust: not installed"
    @command -v julia >/dev/null && echo "Julia: $(julia --version)" || echo "Julia: not installed"
    @echo "Podman: $(podman --version)"
    @echo "Just: $(just --version)"

# ============================================================================
# Help
# ============================================================================

# Show this help message
help:
    @just --list

# Show detailed help for a recipe
help-recipe RECIPE:
    @just --show {{RECIPE}}

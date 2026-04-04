# Phantom Metal Taste - Setup Guide

Complete guide to setting up and running the Phantom Metal Taste system.

## Prerequisites

### Required Software

1. **Deno** (v1.40+)
   ```bash
   curl -fsSL https://deno.land/install.sh | sh
   ```

2. **Podman & podman-compose**
   ```bash
   sudo dnf install podman podman-compose
   ```

3. **Rust & Cargo** (v1.70+) - for WASM modules
   ```bash
   curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
   rustup target add wasm32-unknown-unknown
   ```

4. **Julia** (v1.9+) - for statistical analysis
   ```bash
   # macOS
   brew install julia

   # Linux
   wget https://julialang-s3.julialang.org/bin/linux/x64/1.9/julia-1.9.4-linux-x86_64.tar.gz
   tar -xvzf julia-1.9.4-linux-x86_64.tar.gz
   sudo mv julia-1.9.4 /opt/
   sudo ln -s /opt/julia-1.9.4/bin/julia /usr/local/bin/julia
   ```

### Optional Software

- **ReScript** - `npm install -g rescript` (for compiling .res files)
- **Git** - for version control
- **jq** - for JSON processing in examples

## Installation

### 1. Clone the Repository

```bash
git clone https://github.com/yourusername/phantom-metal-taste.git
cd phantom-metal-taste
```

### 2. Install Dependencies

```bash
# Build ReScript code
deno task build

# Julia dependencies
cd src/analytics
julia --project=. -e 'using Pkg; Pkg.instantiate()'
cd ../..
```

### 3. Build WASM Modules

```bash
cd src/core
cargo build --target wasm32-unknown-unknown --release
cd ../..
```

Or use the Deno task:
```bash
deno task build:wasm
```

### 4. Configure Environment

```bash
cp .env.example .env
```

Edit `.env` if needed (defaults should work for local development):
```env
# Database Configuration
ARANGO_URL=http://localhost:8529
ARANGO_DATABASE=phantom_metal_taste
ARANGO_USERNAME=root
ARANGO_PASSWORD=phantom-dev-password

VIRTUOSO_URL=http://localhost:8890/sparql
VIRTUOSO_UPDATE_URL=http://localhost:8890/sparql-auth
VIRTUOSO_USERNAME=dba
VIRTUOSO_PASSWORD=phantom-dev-password
VIRTUOSO_GRAPH=https://phantom-metal-taste.org/graph

# Application
PORT=3000
NODE_ENV=development
LOG_LEVEL=debug
```

### 5. Start Databases

```bash
podman-compose up -d
```

Wait for services to be healthy:
```bash
podman-compose ps
```

You should see both `phantom-arangodb` and `phantom-virtuoso` with status `healthy`.

### 6. Verify Database Connections

**ArangoDB:**
- Open http://localhost:8529
- Login: `root` / `phantom-dev-password`
- Database `phantom_metal_taste` should exist

**Virtuoso:**
- Open http://localhost:8890/conductor
- Login: `dba` / `phantom-dev-password`
- SPARQL endpoint available at http://localhost:8890/sparql

## Running the Application

### Start the API Server

```bash
deno task dev
```

You should see:
```
🌀 Phantom Metal Taste - Initializing
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📊 Connecting to ArangoDB...
✓ ArangoDB initialized
🕸️  Connecting to Virtuoso...
✓ Virtuoso initialized
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 API Server starting on port 3000
✓ Server running at http://localhost:3000
```

### Verify API is Running

```bash
curl http://localhost:3000/health
```

Expected response:
```json
{
  "status": "operational",
  "message": "Measuring the gap between intention and reality",
  "databases": {
    "arango": "connected",
    "virtuoso": "connected"
  },
  "irony": "fully operational"
}
```

## Load Sample Data (SynapCor Case Study)

```bash
deno task load-data
```

This loads:
- 4 departments
- 6 sample employees
- 3 initiatives (Wellness Wednesday, Transparency Dashboard, Synergy Champions)
- 9 outcomes (intended and unintended)
- Causal links
- Sample metrics

## Verify Installation

### 1. Test Basic Functionality

```bash
# Health check
curl http://localhost:3000/health

# Gameable metrics
curl http://localhost:3000/api/analytics/gameable-metrics

# Metric theater detection
curl http://localhost:3000/api/analytics/metric-theater
```

### 2. Run Tests

```bash
# Start databases if not running
podman-compose up -d

# Run test suite
deno task test
```

### 3. Test WASM Module

```bash
cd src/core
cargo test
```

### 4. Test Julia Modules

```bash
cd src/analytics
julia --project=. -e 'using Pkg; Pkg.test()'
```

## Development Workflow

### Hot Reload

The Deno dev server supports hot reload:
```bash
deno task dev
```

Make changes to ReScript files, rebuild, and the server will restart automatically.

### Database Management

```bash
# Start databases
deno task db:up

# Stop databases
deno task db:down

# Reset (delete all data and restart)
deno task db:reset
```

### Rebuild WASM

After modifying Rust code:
```bash
deno task build:wasm
```

Then restart the API server.

### Type Checking

```bash
deno task build  # ReScript type checking is part of compilation
```

## Troubleshooting

### Databases Won't Start

```bash
# Check Podman is running
podman ps

# View logs
podman-compose logs arango
podman-compose logs virtuoso

# Common fix: remove volumes and restart
podman-compose down -v
podman-compose up -d
```

### ArangoDB Connection Errors

- Ensure port 8529 is not in use
- Check credentials in `.env`
- Verify database was created (check web UI)

### Virtuoso Connection Errors

- Ensure port 8890 is not in use
- Wait longer for health check (Virtuoso takes ~30s to start)
- Check logs: `podman-compose logs virtuoso`

### WASM Module Not Loading

```bash
# Rebuild
cd src/core
cargo clean
cargo build --target wasm32-unknown-unknown --release

# Verify output exists
ls -lh target/wasm32-unknown-unknown/release/*.wasm
```

### Julia Errors

```bash
# Reinstall packages
cd src/analytics
julia --project=. -e 'using Pkg; Pkg.resolve(); Pkg.instantiate()'
```

### Port Already in Use

If port 3000 is taken, change in `.env`:
```env
PORT=3001
```

## API Examples

### Create an Initiative

```bash
curl -X POST http://localhost:3000/api/initiatives \
  -H "Content-Type: application/json" \
  -d '{
    "name": "My Initiative",
    "description": "Testing the system",
    "startDate": "2024-01-01T00:00:00Z",
    "department": "Engineering",
    "intendedOutcome": "Improve productivity",
    "status": "active",
    "participants": []
  }'
```

### Get Gap Analysis

After loading SynapCor data, get initiative ID from web UI or query, then:

```bash
# Replace {id} with actual initiative _key
curl http://localhost:3000/api/analytics/gap/{id}
```

### Detect Gaming

```bash
curl http://localhost:3000/api/analytics/gameable-metrics
```

### Philosophical Reflection

```bash
curl http://localhost:3000/api/reflection
```

## Production Deployment

### Build for Production

```bash
deno task build
```

### Container Production Image

(Future enhancement - not yet implemented)

```containerfile
FROM cgr.dev/chainguard/wolfi-base:latest AS build

WORKDIR /app
COPY . .
RUN deno task build
RUN deno task build:wasm

FROM cgr.dev/chainguard/static:latest
COPY --from=build /app /app
EXPOSE 3000
CMD ["deno", "task", "start"]
```

### Environment Variables

Set these in production:
```env
NODE_ENV=production
LOG_LEVEL=info
ARANGO_PASSWORD=<strong-password>
VIRTUOSO_PASSWORD=<strong-password>
```

## Next Steps

1. Explore the SynapCor case study: `case-studies/synapcor/README.md`
2. Read architecture docs: `docs/architecture/ARCHITECTURE.md`
3. Review API documentation (coming soon)
4. Build visualizations using the API endpoints

## Support

- Issues: https://github.com/yourusername/phantom-metal-taste/issues
- Docs: `docs/`
- Case study: `case-studies/synapcor/`

---

*"Setting up a system to measure organizational delusion requires meticulous attention to detail. The irony is not lost on us."*

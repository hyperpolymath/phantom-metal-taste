# Phantom Metal Taste - Quickstart Guide

Get up and running in 5 minutes.

## Prerequisites

Install these first:
- [Deno](https://deno.land) - `curl -fsSL https://deno.land/install.sh | sh`
- [Podman](https://podman.io) - `sudo dnf install podman podman-compose`

## Installation

```bash
# 1. Clone (or you already have it)
cd phantom-metal-taste

# 2. Build ReScript code
deno task build

# 3. Start databases (takes ~30 seconds)
podman-compose up -d

# 4. Wait for databases to be healthy
podman-compose ps
# Both should show "healthy" status

# 5. Start the API server
deno task dev
```

You should see:
```
✓ ArangoDB initialized
✓ Virtuoso initialized
✓ Server running at http://localhost:3000
```

## Load Sample Data

In a new terminal:
```bash
deno task load-data
```

This loads a complete fictional company with initiatives, outcomes, and metrics.

## Try It Out

### 1. Health Check
```bash
curl http://localhost:3000/health
```

### 2. Find Gameable Metrics
```bash
curl http://localhost:3000/api/analytics/gameable-metrics | jq
```

Looks for metrics with suspicious gaps between target and actual values.

### 3. Detect Metric Theater
```bash
curl http://localhost:3000/api/analytics/metric-theater | jq
```

Finds metrics that are collected but never used.

### 4. Philosophical Reflection
```bash
curl http://localhost:3000/api/reflection | jq
```

The system questions itself.

### 5. Run the Demo
```bash
./scripts/demo.sh
```

Interactive demo of key features.

## Explore

### Web Interfaces

- **ArangoDB**: http://localhost:8529
  - Login: `root` / `phantom-dev-password`
  - Browse collections, run AQL queries
  - View the causal graph visually

- **Virtuoso**: http://localhost:8890/conductor
  - Login: `dba` / `phantom-dev-password`
  - Run SPARQL queries
  - Explore the ontology

### API Endpoints

All endpoints return JSON:

```bash
# Create an initiative
curl -X POST http://localhost:3000/api/initiatives \
  -H "Content-Type: application/json" \
  -d '{
    "name": "My Test Initiative",
    "description": "Testing the system",
    "startDate": "2024-01-01T00:00:00Z",
    "department": "Engineering",
    "intendedOutcome": "Learn the system",
    "status": "active",
    "participants": []
  }'

# Get gap analysis for an initiative (replace {id} with actual _key)
curl http://localhost:3000/api/analytics/gap/{id} | jq

# Find unintended consequences
curl http://localhost:3000/api/initiatives/{id}/unintended | jq
```

## Project Structure

```
phantom-metal-taste/
├── src/
│   ├── orchestrator/         # ReScript services
│   │   ├── Index.res        # Main API entry point
│   │   ├── Config.res       # Configuration
│   │   ├── Types.res        # Type definitions
│   │   └── db/              # Database connections
│   ├── core/                # Rust/WASM modules
│   └── analytics/           # Julia statistical analysis
├── case-studies/
│   └── synapcor/            # Sample company data
├── tests/                   # Test suite
├── docs/                    # Documentation
└── compose.yml              # Database setup
```

## Common Tasks

### Reset Everything
```bash
deno task db:reset  # Deletes all data and restarts
```

### Run Tests
```bash
deno task test
```

### Stop Databases
```bash
podman-compose down
```

### View Logs
```bash
podman-compose logs -f arango
podman-compose logs -f virtuoso
```

## Next Steps

1. Read the [SynapCor Case Study](case-studies/synapcor/README.md) - understand the fictional company
2. Review [Architecture Documentation](docs/architecture/ARCHITECTURE.md) - deep dive into design
3. Check [Setup Guide](docs/SETUP.md) - comprehensive setup with troubleshooting
4. Read [CLAUDE.md](CLAUDE.md) - guidelines for AI-assisted development

## Understanding the Data

The SynapCor case study includes:
- **Wellness Wednesday**: Meditation program that created stress
- **Transparency Dashboard**: Public metrics that led to gaming
- **Synergy Champions**: Recognition program that decreased productivity

Each demonstrates the gap between good intentions and actual outcomes.

## Philosophy

This system measures organizational delusion by:
1. Tracking stated intentions
2. Recording actual outcomes
3. Calculating the gap
4. Detecting when metrics are gamed
5. Identifying when metrics become theater

The irony: A rigorous system to measure the limits of rigorous systems.

## Troubleshooting

**Databases won't start?**
```bash
podman-compose down -v
podman-compose up -d
```

**API won't connect to databases?**
- Wait for "healthy" status: `podman-compose ps`
- Check logs: `podman-compose logs arango`

**Port 3000 already in use?**
- Change in `.env`: `PORT=3001`

**Need help?**
- See [docs/SETUP.md](docs/SETUP.md) for detailed troubleshooting

## That's It!

You now have a working multi-model database system for measuring the gap between corporate intentions and reality. Explore the APIs, query the data, and contemplate the meta-ironies.

*"The map is not the territory, but sometimes the map reveals what the territory conceals."*

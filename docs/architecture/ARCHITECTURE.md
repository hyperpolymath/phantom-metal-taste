# Phantom Metal Taste - Architecture Documentation

## Overview

Phantom Metal Taste is a multi-model database architecture designed to capture, analyze, and visualize the gap between organizational intentions and actual outcomes. This document provides a comprehensive architectural overview.

## Architectural Principles

### 1. Multi-Model Paradigm

The system employs multiple database paradigms simultaneously:

- **Graph Database (ArangoDB)**: Models causal relationships, organizational structure, and temporal sequences
- **Semantic Web (Virtuoso)**: Provides formal ontological reasoning and inference capabilities

**Rationale**: Different data models reveal different truths. Graph databases excel at traversing relationships; semantic databases excel at formal reasoning.

### 2. Polyglot Implementation

```
┌─────────────────────────────────────────────────┐
│           ReScript/Deno (Orchestration)          │
│  • API Layer                                    │
│  • Service coordination                         │
│  • Multi-model synchronization                  │
└─────────────────────────────────────────────────┘
                        ▼
┌─────────────────┬───────────────────────────────┐
│  Rust/WASM      │  Julia (Statistical)          │
│  • Core metrics │  • Impact analysis            │
│  • Gap calc     │  • Causal inference           │
│  • Performance  │  • Gaming detection           │
└─────────────────┴───────────────────────────────┘
                        ▼
┌─────────────────┬───────────────────────────────┐
│  ArangoDB       │  Virtuoso                     │
│  • Graph data   │  • RDF triples                │
│  • Traversal    │  • SPARQL queries             │
│  • Documents    │  • Inference rules            │
└─────────────────┴───────────────────────────────┘
```

**Rationale**: Use each language for its strengths:
- ReScript/Deno: Sound types, secure runtime, excellent DX
- Rust/WASM: Performance-critical calculations, portable
- Julia: Statistical computing, multiple dispatch

### 3. Event-Driven Causality

The system models organizational dynamics as a directed acyclic graph (DAG) of causal relationships:

```
[Initiative] --causes--> [Intended Outcome]
     |
     +--causes--> [Unintended Outcome 1]
     |
     +--causes--> [Unintended Outcome 2]
             |
             +--causes--> [Emergent Outcome]
```

Each edge has:
- **Strength** (0-1): Confidence in causal relationship
- **Type**: direct, indirect, spurious
- **Evidence**: Supporting data for the link

## Data Model

### ArangoDB Collections

**Vertex Collections:**
- `initiatives`: Corporate programs and interventions
- `outcomes`: Results (intended, unintended, emergent)
- `employees`: People in the organization
- `metrics`: Quantitative measurements
- `departments`: Organizational units
- `events`: Time-stamped occurrences

**Edge Collections:**
- `causes`: Causal relationships
- `participates_in`: Employee involvement
- `measures`: What metrics measure
- `belongs_to`: Organizational membership
- `influences`: Initiative influence

**Named Graph:**
- `causal_graph`: Unified graph encompassing all relationships

### Virtuoso Ontology

**Core Classes (OWL):**
```turtle
pmt:Initiative rdf:type owl:Class ;
  rdfs:label "Corporate Initiative" .

pmt:Outcome rdf:type owl:Class ;
  rdfs:label "Outcome" .

pmt:Employee rdfs:subClassOf foaf:Person .

pmt:Metric rdf:type owl:Class .
```

**Object Properties:**
```turtle
pmt:causes rdf:type owl:ObjectProperty ;
  rdfs:domain pmt:Initiative ;
  rdfs:range pmt:Outcome .

pmt:intends rdf:type owl:ObjectProperty ;
  rdfs:domain pmt:Initiative ;
  rdfs:range pmt:Outcome ;
  rdfs:comment "The intended outcome (may differ from actual)" .
```

**Key Insight**: The ontology distinguishes between `intends` (what was meant to happen) and `causes` (what actually happened). This is the core of the "phantom metal taste" metric.

## Core Algorithms

### 1. Intention-Reality Gap Calculation

```typescript
gapScore = (
  unintendedOutcomes.count * 10 +
  avgMetricGap * 50 +
  (intendedOutcomes.count === 0 ? 25 : 0)
) min 100
```

**Components:**
- **Unintended outcomes**: More = bigger gap
- **Metric gaps**: Difference between targets and actuals
- **Missing intentions**: Not measuring intended outcomes is suspicious

### 2. Causal Path Tracing

Uses graph traversal with strength propagation:

```
pathStrength = geometricMean(edgeStrengths)
             = (s1 × s2 × ... × sn)^(1/n)
```

**Rationale**: Geometric mean accounts for weakest links (a chain is only as strong as its weakest link).

### 3. Gaming Detection (Julia)

Statistical analysis looking for:
- Suspiciously low variance (coefficient of variation < 0.05)
- End-of-period spikes (>30% increase in final window)
- Target clustering (>60% of values near target)
- Discontinuities (>20% large jumps)

### 4. Metric Theater Detection

Metrics are "theater" if:
```
theaterProbability = unlinkedMeasurements / totalMeasurements

if (collectionRate > 10 && theaterProbability > 0.8) {
  verdict = "METRIC THEATER DETECTED"
}
```

## API Architecture

### REST Endpoints

```
POST   /api/initiatives              # Create initiative
POST   /api/initiatives/:id/outcomes # Link to outcome
GET    /api/initiatives/:id/analysis # Get analysis

GET    /api/analytics/gap/:id        # Intention-reality gap
GET    /api/analytics/path/:from/:to # Causal paths
GET    /api/analytics/gameable-metrics # Gameable metrics
GET    /api/analytics/metric-theater   # Theater detection
GET    /api/analytics/department/:id/synergy # Synergy score

GET    /api/visualizations/graph     # Causal graph data
GET    /api/visualizations/timeseries # Metric trends
GET    /api/visualizations/heatmap   # Department heatmap
```

### Service Layer

```typescript
InitiativeService
  - createInitiative()
  - linkCause()
  - getInitiativeWithOutcomes()
  - findUnintendedConsequences()

AnalyticsService
  - calculateIntentionRealityGap()
  - traceCausalPath()
  - findGameableMetrics()
  - detectMetricTheater()
  - calculateDepartmentSynergy()

VisualizationService
  - getCausalGraphData()
  - getMetricTimeSeries()
  - getDepartmentSynergyHeatmap()
  - getIntentionRealityScatter()
```

## Data Flow

### Write Path

```
1. Client POSTs initiative
2. ReScript service validates (type system)
3. Service writes to ArangoDB
4. Service syncs to Virtuoso (RDF triples)
5. Return created entity
```

### Analysis Path

```
1. Client requests gap analysis
2. Service queries ArangoDB (AQL)
3. Results passed to Rust/WASM for calculations
4. Statistical analysis via Julia subprocess
5. Aggregate results
6. Return to client
```

### Visualization Path

```
1. Client requests graph visualization
2. Service performs graph traversal (AQL)
3. Transform to visualization format
4. Return nodes + edges JSON
5. Client renders (D3.js/similar)
```

## Deployment Architecture

### Development

```
┌─────────────────┐
│ Podman Compose  │
├─────────────────┤
│  • ArangoDB     │
│  • Virtuoso     │
└─────────────────┘
        ▼
┌─────────────────┐
│   Deno Runtime  │
│  (localhost)    │
└─────────────────┘
```

### Production (Theoretical)

```
┌──────────────────────────────┐
│       Load Balancer          │
└──────────────────────────────┘
              ▼
┌──────────────────────────────┐
│   API Pods (Kubernetes)      │
│   • Deno runtime             │
│   • WASM modules loaded      │
└──────────────────────────────┘
              ▼
┌──────────────┬───────────────┐
│  ArangoDB    │   Virtuoso    │
│  Cluster     │   Cluster     │
└──────────────┴───────────────┘
```

## Performance Considerations

### 1. WASM for Hot Paths

Metric gap calculations run in Rust/WASM:
- ~10x faster than interpreted JavaScript
- Portable across runtimes
- Memory-safe

### 2. AQL Query Optimization

- Indexes on `_from`, `_to` for edge traversal
- Limit graph depth to prevent explosion
- Use early filtering in traversals

### 3. Julia for Statistical Heavy Lifting

- Compiled just-in-time
- Near-C performance for numerical operations
- Excellent for matrix operations

### 4. Caching Strategy

- Query results cached (15 min TTL)
- WASM modules loaded once at startup
- Virtuoso inference cached per graph

## Security Considerations

### 1. Database Authentication

- Separate credentials per environment
- Never commit passwords (use .env)
- Rotate credentials quarterly

### 2. Input Validation

- ReScript type system for all inputs
- Parameterized queries (prevent injection)
- Rate limiting on API endpoints

### 3. Data Privacy

This is a critical system - it tracks employee metrics. Considerations:
- Anonymization options for sensitive data
- Access controls by role
- Audit logging of all queries
- GDPR compliance (right to deletion)

## Philosophical Considerations

### The Measurement Paradox

This system measures the gap between intention and reality. But:
- Measuring the gap may change the gap (Heisenberg)
- Gaming metrics is rational behavior
- The map is not the territory

### The Irony Stack

Layer by layer:
1. **Surface**: Enterprise-grade architecture
2. **Intent**: Measure corporate delusion
3. **Reality**: The system itself could become metric theater
4. **Meta**: This documentation acknowledges that

### Design for Skepticism

The system should:
- Make gaming visible, not prevent it
- Reveal contradictions, not resolve them
- Measure what we can, admit what we can't
- Question its own metrics

## Future Enhancements

1. **Machine Learning Integration**
   - Predict unintended consequences
   - Anomaly detection improvements
   - Causal discovery automation

2. **Real-time Stream Processing**
   - Event stream from metrics
   - Real-time gap calculation
   - Alert on threshold breaches

3. **Natural Language Interface**
   - Query causal graph in English
   - Generate narrative explanations
   - LLM-powered insight generation

4. **Temporal Analysis**
   - Track gap evolution over time
   - Identify patterns in gaming behavior
   - Forecast initiative outcomes

---

*"The architecture is rigorous. The metrics are precise. The irony is intentional."*

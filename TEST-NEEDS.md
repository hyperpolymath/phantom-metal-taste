# TEST-NEEDS.md — phantom-metal-taste

## CRG Grade: C — ACHIEVED 2026-04-04

## Current Test State

| Category | Count | Notes |
|----------|-------|-------|
| Rust unit tests | 4 | `src/core/src/lib.rs` `#[cfg(test)]` — all passing |
| Julia tests | 0 | `src/analytics/` — no test suite yet |
| ReScript tests | 0 | `src/orchestrator/` — no test suite yet |
| Integration tests | 0 | Requires ArangoDB + Virtuoso (containers) |

## What's Covered

- [x] `calculate_metric_gaps` — parses JSON, returns gap structs
- [x] `calculate_path_strength` — geometric mean of edge weights
- [x] `calculate_synergy_score` — penalises suspiciously uniform high scores
- [x] `phantom_metal_taste_score` — composite score from outcome/gap/theater inputs

## CI Gate

```bash
cd src/core && cargo test
```

## Known Failures / Limitations

- `wasm-bindgen` dependency: tests compile via `rlib` but WASM target untested
- `calculate_metric_gaps` test only checks string presence, not parsed values
- `detect_metric_anomalies` and `detect_metric_theater` have no test coverage
- Julia analytics (`src/analytics/`) untested
- ReScript orchestrator (`src/orchestrator/`) untested
- Integration tests require running ArangoDB + Virtuoso containers
- `benchmarks/gap_calculation.bench.ts` — TypeScript (banned language)

## Still Missing (for CRG B+)

- [ ] Tests for `detect_metric_anomalies` and `detect_metric_theater`
- [ ] Julia test suite for `causal_inference.jl` and `impact_analysis.jl`
- [ ] ReScript/Deno tests for orchestrator layer
- [ ] Migrate `benchmarks/gap_calculation.bench.ts` from TypeScript to Deno
- [ ] 6+ diverse external targets (CRG B requirement)

## Run Tests

```bash
cd src/core && cargo test
```

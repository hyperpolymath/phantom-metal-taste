# Working with Claude on Phantom Metal Taste

This document provides context and guidelines for AI-assisted development on the Phantom Metal Taste project.

## Project Context

**Phantom Metal Taste** is a multi-model database architecture that explores the gap between corporate intentions and actual outcomes. The project has a distinct philosophical undertone—it's both a technical implementation and a critique of organizational measurement systems.

### Core Philosophy

When working on this project, understand that:

1. **The irony is intentional**: This project measures things that arguably shouldn't be measured in the way corporations measure them
2. **Technical rigor matters**: Despite the critical stance, the implementation should be exemplary
3. **Documentation is commentary**: The documentation style balances technical precision with philosophical observation

## Technical Stack

```
┌─────────────────────────────────────────┐
│     ReScript/Deno (Orchestration)       │
├─────────────────────────────────────────┤
│  Rust/WASM  │  Julia (Statistical)      │
├─────────────┼───────────────────────────┤
│  ArangoDB   │  Virtuoso (Semantic Web)  │
└─────────────┴───────────────────────────┘
```

### Key Technologies

- **ArangoDB**: Graph database for modeling causal relationships
- **Virtuoso**: RDF/SPARQL triple store for semantic reasoning
- **ReScript**: Sound type system with 100% coverage, compiles to JavaScript
- **Deno**: Secure runtime with explicit permissions and modern tooling
- **Rust/WebAssembly**: High-performance core algorithms
- **Julia**: Statistical analysis and data science workloads

### Why ReScript + Deno?

This project migrated from TypeScript/Bun to ReScript/Deno to achieve higher levels of correctness and security:

**ReScript provides:**
- **Sound type system**: Impossible states become unrepresentable
- **100% type coverage**: No escape hatches, no `any`, no `unknown`
- **Algebraic data types**: Model domain concepts precisely with variants
- **Pattern matching**: Exhaustive case analysis enforced by compiler
- **No null/undefined**: Use `option<'a>` for optional values
- **Fast compilation**: ~1ms per file, instant feedback
- **Zero-cost abstractions**: Compiles to readable, performant JavaScript

**Deno provides:**
- **Security by default**: Explicit permissions (--allow-net, --allow-read, etc.)
- **Modern standards**: Native ES modules, Web APIs, TypeScript support
- **No node_modules**: URL-based imports, no package.json hell
- **Built-in tooling**: Test runner, formatter, linter included
- **Offline-first**: Works air-gapped after initial dependency fetch

Together, ReScript + Deno form a **type-safe, memory-safe, permission-aware** foundation that aligns with the project's Platinum-level RSR compliance goals.

See [RESCRIPT_MIGRATION.md](RESCRIPT_MIGRATION.md) for detailed migration rationale.

## Code Organization

```
phantom-metal-taste/
├── src/
│   ├── orchestrator/    # ReScript coordination layer (.res files)
│   │   ├── Config.res   # Environment configuration
│   │   ├── Types.res    # Domain model (algebraic data types)
│   │   ├── Index.res    # Entry point
│   │   └── db/          # Database bindings (ArangoDB, Virtuoso)
│   ├── core/            # Rust/WASM modules
│   ├── analytics/       # Julia statistical modules
│   └── ontologies/      # Semantic web ontologies
├── case-studies/
│   └── synapcor/        # Reference implementation
├── docs/
│   ├── architecture/    # TOGAF documentation
│   ├── diagrams/        # UML, DFD, ERD
│   └── ontologies/      # ODM specifications
├── specs/               # TLA+ formal verification
├── benchmarks/          # Performance benchmarks
└── tests/
```

## Development Guidelines

### 1. Multi-Model Consistency

When modifying data structures, ensure consistency across:
- ArangoDB graph schemas
- Virtuoso RDF ontologies
- ReScript algebraic data types (variants, records)
- Rust structs
- Julia type definitions

### 2. Semantic Precision

This project uses formal ontologies. When adding new concepts:
- Define them in the appropriate OWL/RDF ontology first
- Ensure proper subsumption relationships
- Document inference rules clearly
- Use standard vocabularies (FOAF, Dublin Core, etc.) where applicable

### 3. Code Style

**ReScript:**
- Use algebraic data types (variants) for domain modeling
- Prefer pattern matching over conditionals
- Make impossible states unrepresentable in the type system
- Use `option<'a>` instead of null/undefined
- Use `result<'a, 'e>` for operations that can fail
- Keep functions pure where possible
- Example:
  ```rescript
  type initiativeStatus = Planned | Active | Completed | Abandoned

  let statusToString = (status: initiativeStatus): string =>
    switch status {
    | Planned => "planned"
    | Active => "active"
    | Completed => "completed"
    | Abandoned => "abandoned"
    }
  ```

**Rust:**
- Target `wasm32-unknown-unknown`
- Keep allocations minimal (runs in browser)
- Document all public APIs with examples
- Zero `unsafe` blocks in production code
- Use `#[wasm_bindgen]` for JavaScript interop

**Julia:**
- Use type annotations for performance-critical paths
- Leverage multiple dispatch appropriately
- Include benchmark comparisons in comments

### 4. Testing Philosophy

Tests should:
- Validate the model, not just the implementation
- Include edge cases that reveal modeling assumptions
- Use the SynapCor case study as integration test data

### 5. Documentation Tone

Maintain the project's distinctive voice:
- Be technically precise
- Acknowledge the inherent contradictions
- Use philosophical quotes sparingly but meaningfully
- Let the irony emerge from juxtaposition, not explanation

## Common Tasks

### Adding a New Organizational Metric

1. Define the ontological concept in `src/ontologies/`
2. Create the graph schema in ArangoDB
3. Implement measurement logic in appropriate language
4. Add to the SynapCor case study
5. Update documentation with commentary on what's being measured

### Modifying the Graph Schema

1. Update ArangoDB collection definitions
2. Modify Virtuoso RDF mappings
3. Update ReScript type definitions (`Types.res`)
4. Update Rust structs (if WASM modules access these types)
5. Run migration scripts (never drop data)
6. Ensure all variants remain exhaustively pattern-matched

### Performance Optimization

Priority order:
1. Rust/WASM for computational bottlenecks
2. Julia for statistical heavy lifting
3. Database query optimization
4. ReScript optimization (rarely needed - compiler is already efficient)

## Integration Points

### Database Connections

- **ArangoDB**: Uses Foxx microservices for custom logic
- **Virtuoso**: SPARQL endpoint accessible via HTTP
- Both require Podman containers running locally

### WASM Modules

Rust code compiles to WASM and loads via ReScript FFI:
```rescript
// Bindings.res
@module("./core/wasm/analyzer.wasm")
external analyze: (string) => promise<result<float, string>> = "analyze"
```

Build WASM modules with:
```bash
just wasm-build
# Or manually:
cd src/core && cargo build --target wasm32-unknown-unknown --release
```

### Julia Integration

Julia modules called via Deno subprocess:
```rescript
// Bindings.res
@val @scope("Deno")
external runJulia: (string, array<string>) => promise<string> = "run"

// Usage
let result = await runJulia("julia", ["--project=src/analytics", "src/analytics/impact.jl", arg1, arg2])
```

### Build System Workflow

The project uses `just` (modern command runner) for all development tasks:

```bash
# Development workflow
just build          # Compile ReScript → JavaScript
just watch          # Watch mode (recompiles on file changes)
just dev            # Run with Deno in watch mode
just test           # Run all tests
just validate       # Full validation (checks + tests)

# Database management
just db-up          # Start ArangoDB + Virtuoso
just db-down        # Stop databases
just db-health      # Check database status

# Code quality
just fmt            # Format code (Deno)
just lint           # Lint code
just typecheck      # Type check (ReScript + Rust)
just check          # All quality checks

# WASM and Julia
just wasm-build     # Build Rust → WASM
just wasm-test      # Test Rust code
just julia-test     # Test Julia modules

# RSR compliance
just rsr-verify     # Verify RSR compliance
```

**ReScript Compilation:**
- Files end in `.res` (ReScript source)
- Compiler outputs `.bs.js` (JavaScript) in same directory
- Import compiled modules in Deno: `import { foo } from "./Foo.bs.js"`
- Configuration: `bsconfig.json`

**Deno Execution:**
- Requires explicit permissions: `--allow-net`, `--allow-read`, `--allow-env`
- Import maps in `deno.json` simplify imports
- No `package.json` or `node_modules`

## Important Context

### The SynapCor Case Study

SynapCor is a fictional company with a data-driven "wellness" program called the Synergy Matrix. It serves as:
- Reference implementation
- Integration test fixture
- Documentation through narrative
- Cautionary tale

When adding features, consider: "How would SynapCor misuse this?"

### Architectural Decisions

Key choices documented in `docs/architecture/`:
- Why multi-model? (Different paradigms reveal different truths)
- Why semantic web? (Formal logic for informal systems)
- Why graph databases? (Causality is relational)

Review these before proposing architectural changes.

## Testing & Validation

### Running Tests

```bash
# Full test suite
just test

# Build ReScript code
just build

# Rust unit tests
just wasm-test
# Or manually: cd src/core && cargo test

# Julia tests
just julia-test
# Or manually: julia --project=src/analytics -e 'using Pkg; Pkg.test()'

# Integration tests (requires databases)
just db-up
just test

# Full validation (all checks + tests)
just validate
```

### Validation Checklist

Before committing:
- [ ] All tests pass (`just test`)
- [ ] ReScript compiles without warnings (`just build`)
- [ ] Rust type checks pass (`just wasm-check`)
- [ ] WASM modules rebuilt if Rust changed (`just wasm-build`)
- [ ] Ontologies validate against OWL DL
- [ ] Documentation reflects changes
- [ ] SynapCor case study still works
- [ ] RSR compliance maintained (`just rsr-verify`)

## Deployment

This is an experimental project. Deployment is:
- Podman Compose for local development
- Kubernetes manifests in `k8s/` (theoretical)
- No production environment (what would that even mean?)

## Common Pitfalls

1. **Forgetting the graph**: Changes to ReScript types often need graph schema updates
2. **Ontology drift**: RDF and code can diverge; validate regularly
3. **WASM memory**: Limited heap in browser context
4. **Julia startup time**: Cache compiled modules for development
5. **Semantic query performance**: SPARQL can be slow; use ArangoDB for hot paths
6. **ReScript compilation**: Remember to run `just build` after editing `.res` files
7. **Pattern matching exhaustiveness**: When adding new variants, update all pattern matches
8. **FFI boundaries**: Be careful with JavaScript interop - types are not guaranteed at runtime

## Questions to Ask

When uncertain about design decisions:

- Does this capture what's actually happening or what's supposed to happen?
- How would this metric be gamed?
- What does this measurement obscure?
- Is the added complexity worth the analytical insight?

## Resources

### Language Documentation
- [ReScript Language Manual](https://rescript-lang.org/docs/manual/latest/)
- [ReScript Standard Library](https://rescript-lang.org/docs/manual/latest/api)
- [Deno Manual](https://deno.land/manual)
- [Rust Book](https://doc.rust-lang.org/book/)
- [Julia Documentation](https://docs.julialang.org/)

### Database & Semantic Web
- [ArangoDB AQL Documentation](https://www.arangodb.com/docs/stable/aql/)
- [Virtuoso SPARQL Reference](http://docs.openlinksw.com/virtuoso/)
- [OWL 2 Primer](https://www.w3.org/TR/owl2-primer/)

### Architecture & Standards
- [TOGAF Framework](https://www.opengroup.org/togaf)
- [TLA+ Specification Language](https://lamport.azurewebsites.net/tla/tla.html)
- [RSR Framework](https://github.com/example/rhodium-minimal)

## Getting Help

For technical questions:
- Check `docs/architecture/` for design rationale
- Review the SynapCor implementation
- Search issues for similar challenges

For philosophical questions:
- That's part of the journey

---

*"The best way to understand a system is to build a model of it. The best way to critique a system is to build a rigorous model of it."*

# Migration to ReScript + Deno

This document describes the architectural migration from TypeScript/Bun/npm to ReScript + Deno.

## Why ReScript?

**ReScript** is a robustly typed functional programming language that compiles to highly optimized JavaScript. Benefits:

### 1. Type Safety
- **Sound type system** - no `any`, no `undefined` surprises
- **100% type coverage** - if it compiles, it works
- **Fast compiler** - instant feedback loop

### 2. Functional Paradigm
- **Immutable by default** - prevents entire classes of bugs
- **Pattern matching** - exhaustive case handling
- **Algebraic data types** - model complex domains precisely

### 3. Performance
- **Zero-cost abstractions** - compiles to clean, readable JavaScript
- **Tree-shaking friendly** - small bundle sizes
- **Optimized output** - faster than hand-written JS

### 4. JavaScript Interop
- **Seamless FFI** - call any JavaScript library
- **Gradual adoption** - mix ReScript and JS
- **External bindings** - type-safe wrappers for APIs

## Why Deno?

**Deno** is a modern, secure JavaScript/TypeScript runtime. Benefits:

### 1. Security First
- **Explicit permissions** - no file/network access by default
- **Sandboxed execution** - granular control
- **Secure by design** - no package.json vulnerabilities

### 2. Built-in Tools
- **Test runner** - `deno test`
- **Formatter** - `deno fmt`
- **Linter** - `deno lint`
- **Bundler** - `deno bundle`

### 3. Modern Standards
- **ES modules** - native import/export
- **Web APIs** - fetch, URL, streams
- **TypeScript native** - no build step needed

### 4. No node_modules
- **URL imports** - fetch dependencies directly
- **No package.json** - simpler dependency management
- **Version in URL** - explicit, immutable

## Architecture Changes

### Before (TypeScript + Bun + npm)

```
TypeScript source (.ts files)
    ↓
tsc (TypeScript compiler)
    ↓
JavaScript output
    ↓
Bun runtime
    ↓
node_modules dependencies
```

### After (ReScript + Deno)

```
ReScript source (.res files)
    ↓
rescript (ReScript compiler)
    ↓
JavaScript output (.bs.js files)
    ↓
Deno runtime
    ↓
URL-based dependencies
```

## File Structure Changes

### Removed Files
- ❌ `package.json` - npm configuration
- ❌ `tsconfig.json` - TypeScript configuration
- ❌ `node_modules/` - npm dependencies
- ❌ `*.ts` files - TypeScript source

### Added Files
- ✅ `deno.json` - Deno configuration
- ✅ `bsconfig.json` - ReScript configuration
- ✅ `*.res` files - ReScript source
- ✅ `*.bs.js` files - Compiled JavaScript (gitignored)

## Dependency Management

### Before (npm)
```json
{
  "dependencies": {
    "arangojs": "^8.8.1",
    "hono": "^3.11.7"
  }
}
```

### After (Deno import maps)
```json
{
  "imports": {
    "hono/": "https://deno.land/x/hono@v3.11.7/",
    "std/": "https://deno.land/std@0.208.0/"
  }
}
```

## Type System Comparison

### TypeScript
```typescript
interface Initiative {
  _key?: string;
  name: string;
  status: 'planned' | 'active' | 'completed' | 'abandoned';
}

function createInitiative(init: Initiative): Promise<Initiative> {
  // Implementation - could return undefined, throw, etc.
}
```

### ReScript
```rescript
type initiativeStatus = Planned | Active | Completed | Abandoned

type initiative = {
  key: option<string>,
  name: string,
  status: initiativeStatus,
}

let createInitiative = async (init: initiative): promise<initiative> => {
  // Implementation - type system guarantees return type
}
```

**Key Differences:**
- ReScript uses variants (`Planned | Active`) instead of string unions
- `option<'a>` instead of `T | undefined`
- No implicit `null` or `undefined`
- Pattern matching ensures exhaustive handling

## External Bindings

ReScript interops with JavaScript through external bindings:

```rescript
// Deno API bindings
module Deno = {
  module Env = {
    @val @scope("Deno.env")
    external get: string => option<string> = "get"
  }
}

// Usage
let port = Deno.Env.get("PORT")
```

This provides type-safe access to JavaScript APIs.

## Development Workflow

### Install Prerequisites

```bash
# Install ReScript compiler
npm install -g rescript

# Install Deno
curl -fsSL https://deno.land/install.sh | sh
```

### Build and Run

```bash
# Build ReScript → JavaScript
deno task build

# Run with Deno
deno task dev

# Or combined
deno task build && deno task dev
```

### Watch Mode

ReScript has fast incremental compilation:

```bash
# Terminal 1: Watch ReScript files
rescript build -w

# Terminal 2: Run with Deno watch
deno task dev
```

### Testing

```bash
# Run Deno tests
deno task test

# Or with permissions
deno test --allow-net --allow-env --allow-read tests/
```

## Migration Steps Performed

### 1. Configuration
- ✅ Created `deno.json` with tasks and import maps
- ✅ Created `bsconfig.json` for ReScript compiler
- ✅ Removed `package.json` and `tsconfig.json`

### 2. Type Definitions
- ✅ Converted TypeScript interfaces to ReScript types
- ✅ Created `Types.res` with algebraic data types
- ✅ Added helper functions for type conversions

### 3. Core Modules
- ✅ Created `Config.res` for environment configuration
- ✅ Created `Bindings.res` for JavaScript FFI
- ✅ Converted `ArangoDb.ts` → `ArangoDb.res`
- ⏳ VirtuosoDb module (in progress)

### 4. Services
- ⏳ InitiativeService conversion
- ⏳ AnalyticsService conversion
- ⏳ VisualizationService conversion

### 5. API Layer
- ⏳ HTTP server with Deno
- ⏳ Route handlers in ReScript
- ⏳ JSON serialization/deserialization

### 6. Documentation
- ✅ This migration guide
- ⏳ Updated README.md
- ⏳ Updated SETUP.md
- ⏳ Updated architecture docs

## Advantages of This Migration

### 1. Type Safety
**Before (TypeScript):**
```typescript
const gap = calculateGap(initiative);
// Could be undefined, null, throw exception, etc.
```

**After (ReScript):**
```rescript
let gap = calculateGap(initiative)
// Type system guarantees this is a valid result
// Impossible states are unrepresentable
```

### 2. No Runtime Errors
ReScript's type system prevents:
- `undefined is not a function`
- `Cannot read property 'x' of undefined`
- Type coercion bugs
- Null pointer exceptions

### 3. Better Performance
- Smaller bundle sizes
- Faster execution
- Zero-cost abstractions
- Dead code elimination

### 4. Enhanced Security (Deno)
- Explicit permissions model
- No implicit file system access
- No implicit network access
- Secure by default

### 5. Simpler Dependency Management
- No `node_modules` folder
- No package-lock.json conflicts
- Explicit version in imports
- Faster cold starts

## Philosophical Alignment

This migration aligns with the project's philosophy:

**Phantom Metal Taste** measures the gap between intention and reality. The migration to ReScript + Deno:

1. **Reduces gaps** - Sound type system eliminates undefined behavior
2. **Makes intentions explicit** - Algebraic data types model domain precisely
3. **Prevents gaming** - Impossible to "game" the type system
4. **Embraces rigor** - Functional programming enforces discipline

The irony: We're using the most rigorous tools to critique organizational rigor.

## What Stays the Same

- ✅ **Rust/WASM modules** - unchanged, still performance-critical
- ✅ **Julia analytics** - unchanged, still statistical heavy lifting
- ✅ **ArangoDB** - same database, same queries
- ✅ **Virtuoso** - same RDF/semantic layer
- ✅ **Docker Compose** - same infrastructure
- ✅ **API endpoints** - same REST interface
- ✅ **SynapCor case study** - same sample data

## Performance Characteristics

### ReScript Compilation
- **~1ms per file** - instant feedback
- **Incremental** - only changed files rebuild
- **Parallel** - multi-core compilation

### Deno Runtime
- **Fast startup** - no node_modules scan
- **V8 engine** - same as Node.js/Bun
- **Native TypeScript** - no build step for TS

### Bundle Size
ReScript typically produces **30-50% smaller** bundles than equivalent TypeScript due to:
- Better tree-shaking
- Optimized output
- No polyfills needed

## Debugging

### ReScript
```bash
# Compiler errors are excellent
rescript build

# Example error:
# File "src/Types.res", line 42:
# This has type: option<string>
# But expected: string
```

### Deno
```bash
# Built-in debugger
deno run --inspect src/Index.bs.js

# Stack traces include source maps
```

## Migration Status

### Completed ✅
- Configuration files
- Type definitions
- External bindings
- ArangoDB module
- Main entry point
- This documentation

### In Progress ⏳
- Virtuoso module
- Service layer
- API routes
- Test suite conversion

### Remaining 📋
- Full HTTP server implementation
- Request/response handling
- Visualization endpoints
- Integration tests
- Updated setup guide

## Running the Migrated Version

```bash
# 1. Install ReScript
npm install -g rescript

# 2. Build ReScript code
deno task build

# 3. Start databases
docker-compose up -d

# 4. Run the server
deno task dev
```

## Conclusion

This migration represents a significant architectural improvement:

- **More type-safe** - eliminates runtime type errors
- **More functional** - immutable, pure functions
- **More secure** - Deno's permission model
- **More performant** - optimized compilation
- **Simpler dependencies** - no node_modules

The ReScript + Deno stack is well-suited for a project that values rigor, precision, and philosophical consistency while maintaining the ability to critique systems that claim the same.

---

*"We replaced TypeScript with ReScript because sound type systems prevent the gaps we're trying to measure. The meta-irony continues."*

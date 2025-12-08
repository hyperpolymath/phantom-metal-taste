;;; STATE.scm - Phantom Metal Taste Project State
;;; A checkpoint/restore system for AI conversations
;;; Format: Guile Scheme (homoiconic, human-readable)
;;;
;;; "The best way to critique a system is to build a rigorous model of it."

(define-module (phantom-metal-taste state)
  #:export (state))

;;; ============================================================================
;;; METADATA
;;; ============================================================================

(define metadata
  '((format-version . "1.0.0")
    (project-name . "phantom-metal-taste")
    (created . "2025-12-08")
    (last-updated . "2025-12-08")
    (state-schema . "https://github.com/hyperpolymath/state.scm")))

;;; ============================================================================
;;; CURRENT POSITION
;;; ============================================================================

(define current-position
  '((summary . "Well-architected skeleton with excellent documentation but incomplete implementation")

    (status . "in-progress")
    (completion-percentage . 35)
    (phase . "foundation")

    (what-exists
     ((architecture . "complete")
      (documentation . "excellent")
      (rescript-types . "complete")
      (rescript-arangodb-bindings . "partial")
      (rescript-virtuoso-bindings . "stub-only")
      (rust-wasm-algorithms . "complete-not-compiled")
      (julia-analytics . "complete-not-integrated")
      (formal-specs-tla+ . "complete")
      (case-study-synapcor . "documented-only")
      (build-system-justfile . "complete")
      (docker-compose . "complete")
      (ci-cd-workflows . "complete")))

    (what-works
     ((documentation . "All markdown files render correctly")
      (justfile . "Build commands defined but most fail due to missing deps")
      (docker-compose . "Can start ArangoDB and Virtuoso containers")
      (rust-tests . "6 unit tests pass when cargo test runs locally")))

    (what-does-not-work
     ((rescript-compilation . "Compiler not installed, no .bs.js files")
      (http-server . "Not implemented, only prints placeholder")
      (virtuoso-integration . "TODO comment at Index.res:23")
      (wasm-modules . "Not compiled, no .wasm files in repo")
      (data-loading . "SynapCor case study is documentation only")
      (test-suite . "No Deno tests, no Julia tests, no integration tests")
      (api-endpoints . "None functional")))

    (lines-of-code
     ((rescript . 600)
      (rust . 227)
      (julia . 526)
      (documentation . 4000)
      (total-implementation . 1353)))))

;;; ============================================================================
;;; ROUTE TO MVP V1
;;; ============================================================================

(define mvp-v1-roadmap
  '((definition . "Functional API that can store initiatives, calculate gaps, and return analytics")

    (phases
     ((phase-1
       ((name . "Build & Runtime Foundation")
        (status . "not-started")
        (completion . 0)
        (tasks
         (("Install ReScript compiler and compile .res files" . pending)
          ("Implement Deno HTTP server with routes" . pending)
          ("Complete ArangoDB connection and verify CRUD" . pending)
          ("Create basic API endpoints: GET/POST /initiatives" . pending)))
        (deliverable . "Running HTTP server with ArangoDB persistence")))

      (phase-2
       ((name . "Core Analytics Layer")
        (status . "blocked")
        (completion . 0)
        (depends-on . (phase-1))
        (tasks
         (("Compile Rust to WASM (wasm32-unknown-unknown)" . pending)
          ("Create ReScript FFI bindings for WASM modules" . pending)
          ("Implement gap calculation endpoint" . pending)
          ("Wire up phantom_metal_taste_score algorithm" . pending)))
        (deliverable . "Working gap analysis API")))

      (phase-3
       ((name . "Semantic Layer & Data")
        (status . "blocked")
        (completion . 0)
        (depends-on . (phase-1 phase-2))
        (tasks
         (("Implement Virtuoso SPARQL connection" . pending)
          ("Create RDF ingestion pipeline" . pending)
          ("Build SynapCor data loader script" . pending)
          ("Populate databases with case study data" . pending)))
        (deliverable . "Dual-database system with test data")))

      (phase-4
       ((name . "Testing & Polish")
        (status . "blocked")
        (completion . 0)
        (depends-on . (phase-1 phase-2 phase-3))
        (tasks
         (("Write Deno integration tests" . pending)
          ("Add error handling and validation" . pending)
          ("Performance benchmarking against targets" . pending)
          ("Update documentation to match reality" . pending)))
        (deliverable . "Production-ready MVP")))))

    (minimum-viable-subset
     ((description . "Absolute minimum to demonstrate value")
      (scope . "ArangoDB + ReScript + basic CRUD + gap calculation")
      (excludes . ("Virtuoso" "Julia analytics" "Full test suite"))))))

;;; ============================================================================
;;; ISSUES & BLOCKERS
;;; ============================================================================

(define issues
  '((critical
     ((issue-001
       ((title . "ReScript compiler not installed")
        (impact . "Cannot compile any .res files to executable JavaScript")
        (resolution . "npm install -g rescript && rescript build")
        (status . "open")))

      (issue-002
       ((title . "HTTP server not implemented")
        (impact . "No API endpoints accessible, cannot serve requests")
        (location . "src/orchestrator/Index.res:28")
        (resolution . "Implement Deno.serve() with route handlers")
        (status . "open")))

      (issue-003
       ((title . "Virtuoso integration incomplete")
        (impact . "Semantic web capabilities unavailable")
        (location . "src/orchestrator/Index.res:23")
        (evidence . "TODO comment: 'Implement Virtuoso connection'")
        (resolution . "Implement SPARQL HTTP client bindings")
        (status . "open")))))

    (major
     ((issue-004
       ((title . "WASM modules not compiled")
        (impact . "Performance-critical algorithms unreachable from ReScript")
        (resolution . "cd src/core && cargo build --target wasm32-unknown-unknown --release")
        (status . "open")))

      (issue-005
       ((title . "No data loading mechanism")
        (impact . "Cannot populate databases with SynapCor case study")
        (resolution . "Create load-data.ts script referenced in QUICKSTART.md")
        (status . "open")))

      (issue-006
       ((title . "No test suite")
        (impact . "No automated verification of functionality")
        (resolution . "Create /tests directory with Deno tests")
        (status . "open")))))

    (minor
     ((issue-007
       ((title . "No database connection pooling")
        (impact . "Suboptimal performance under load")
        (status . "deferred")))

      (issue-008
       ((title . "No caching layer")
        (impact . "Repeated expensive calculations")
        (status . "deferred")))

      (issue-009
       ((title . "No authentication/authorization")
        (impact . "API is completely open")
        (status . "deferred")))))))

;;; ============================================================================
;;; QUESTIONS FOR USER
;;; ============================================================================

(define questions
  '((priority-high
     ((q1
       ((question . "What is the deployment target for MVP v1?")
        (context . "Documentation mentions Docker Compose for local dev and theoretical K8s")
        (options . ("Local Docker only" "Cloud deployment" "Both"))
        (impact . "Affects infrastructure decisions and complexity")))

      (q2
       ((question . "Should MVP include Virtuoso or can it be ArangoDB-only initially?")
        (context . "Virtuoso adds semantic reasoning but significantly increases complexity")
        (tradeoff . "Simpler MVP vs full multi-model architecture")
        (impact . "Could reduce MVP scope by 25-30%")))

      (q3
       ((question . "Is Julia integration required for MVP or can it be deferred?")
        (context . "Julia provides advanced statistical analysis but has cold-start penalty")
        (alternative . "Rust WASM already has basic analytics")
        (impact . "Simplifies build pipeline if deferred")))))

    (priority-medium
     ((q4
       ((question . "What HTTP framework preference for Deno?")
        (options . ("Hono (fast, minimal)" "Fresh (full-stack)" "Oak (Express-like)" "Raw Deno.serve"))
        (recommendation . "Hono - aligns with minimal philosophy")))

      (q5
       ((question . "Should the SynapCor case study be realistic fake data or clearly satirical?")
        (context . "Current documentation is satirical but data structure is realistic")
        (impact . "Affects demo narrative and documentation tone")))

      (q6
       ((question . "What is the performance target for gap calculations?")
        (current-benchmark . "src/benchmarks defines 10ms for simple, 250ms for complex")
        (question . "Are these targets still valid?")))))

    (priority-low
     ((q7
       ((question . "Should we maintain RSR Platinum compliance claims?")
        (context . "Documentation claims Platinum but many requirements unmet")
        (options . ("Downgrade to Bronze" "Remove claims" "Work toward actual compliance"))))

      (q8
       ((question . "Any preference on test framework?")
        (options . ("Deno.test (built-in)" "Jest via Deno compat" "Vitest"))
        (recommendation . "Deno.test - no additional dependencies")))))))

;;; ============================================================================
;;; LONG-TERM ROADMAP
;;; ============================================================================

(define long-term-roadmap
  '((vision . "A rigorous system for measuring the gap between organizational intentions and outcomes")

    (milestones
     ((v1-mvp
       ((target . "Functional multi-model database with basic analytics")
        (status . "in-progress")
        (features
         ("ArangoDB graph persistence"
          "Basic CRUD API for initiatives/outcomes/metrics"
          "Gap calculation via Rust WASM"
          "SynapCor demo data"))))

      (v1-1-analytics
       ((target . "Complete analytics suite")
        (status . "planned")
        (depends-on . "v1-mvp")
        (features
         ("Julia statistical integration"
          "Gaming detection algorithms"
          "Metric theater identification"
          "Causal inference with confound control"))))

      (v1-2-semantic
       ((target . "Full semantic web integration")
        (status . "planned")
        (depends-on . "v1-mvp")
        (features
         ("Virtuoso SPARQL endpoint"
          "RDF ontology enforcement"
          "Inference rule execution"
          "Cross-paradigm query interface"))))

      (v2-intelligence
       ((target . "Organizational intelligence platform")
        (status . "conceptual")
        (depends-on . ("v1-1-analytics" "v1-2-semantic"))
        (features
         ("Pattern recognition for systemic issues"
          "Predictive modeling of unintended consequences"
          "Real-time anomaly alerting"
          "Executive dashboards"))))

      (v3-platform
       ((target . "Multi-tenant extensible platform")
        (status . "conceptual")
        (depends-on . "v2-intelligence")
        (features
         ("Custom metric plugins"
          "Multi-tenancy support"
          "Public API for integrations"
          "NLP query interface"
          "ML-based prediction"))))))

    (technical-debt-to-address
     ("Database connection pooling"
      "Caching layer for expensive queries"
      "Authentication and authorization"
      "Rate limiting"
      "Observability and monitoring"
      "Graceful degradation when components unavailable"))

    (philosophical-goals
     ("Maintain intellectual honesty about measurement limitations"
      "Preserve ironic commentary through technical rigor"
      "Demonstrate that critique can be constructive"
      "Show that measuring the unmeasurable requires acknowledging the paradox"))))

;;; ============================================================================
;;; NEXT ACTIONS (CRITICAL)
;;; ============================================================================

(define next-actions
  '((immediate
     (("Install ReScript compiler" . "npm install -g rescript")
      ("Compile ReScript sources" . "rescript build")
      ("Start databases" . "just db-up")
      ("Verify ArangoDB accessible" . "curl http://localhost:8529/_api/version")))

    (this-session
     (("Implement HTTP server in Index.res" . high)
      ("Create basic /health endpoint" . high)
      ("Create /api/initiatives GET endpoint" . high)
      ("Test end-to-end request flow" . high)))

    (next-session
     (("Implement POST /api/initiatives" . medium)
      ("Add initiative persistence to ArangoDB" . medium)
      ("Compile Rust WASM modules" . medium)
      ("Create gap calculation endpoint" . medium)))))

;;; ============================================================================
;;; HISTORY (Completion Snapshots)
;;; ============================================================================

(define history
  '((snapshots
     ((2025-12-08
       ((event . "Initial STATE.scm creation")
        (completion . 35)
        (phase . "foundation")
        (notes . "Project assessed; architecture excellent, implementation incomplete")))))))

;;; ============================================================================
;;; EXPORT
;;; ============================================================================

(define state
  `((metadata . ,metadata)
    (current-position . ,current-position)
    (mvp-v1-roadmap . ,mvp-v1-roadmap)
    (issues . ,issues)
    (questions . ,questions)
    (long-term-roadmap . ,long-term-roadmap)
    (next-actions . ,next-actions)
    (history . ,history)))

;;; ============================================================================
;;; DEPENDENCY GRAPH (for visualization)
;;; ============================================================================

;;; Generate with: (state->dot state)
;;;
;;; phase-1 (Build & Runtime)
;;;    |
;;;    v
;;; phase-2 (Core Analytics) ---> v1-mvp
;;;    |                            |
;;;    v                            +---> v1-1-analytics
;;; phase-3 (Semantic Layer)        |         |
;;;    |                            +---> v1-2-semantic
;;;    v                                      |
;;; phase-4 (Testing & Polish)                v
;;;                                    v2-intelligence
;;;                                           |
;;;                                           v
;;;                                      v3-platform

;;; ============================================================================
;;; IRONY INDEX
;;; ============================================================================

;;; The delicious irony: A system built to measure the gap between intentions
;;; and reality is itself experiencing that exact gap.
;;;
;;; Documented intention: Platinum RSR compliance, multi-model mastery
;;; Current reality: 35% complete, cannot compile, no working endpoints
;;;
;;; phantom_metal_taste_score(this_project) = 0.78
;;;   - High metric_theater_probability (excellent docs, no implementation)
;;;   - Moderate gaming_detection (RSR compliance claims without evidence)
;;;   - Strong causal_attribution (clear path from architecture to incompleteness)
;;;
;;; "We shape our tools, and thereafter our tools shape us." — Marshall McLuhan

// Main entry point for Phantom Metal Taste API server

open Bindings

let main = async () => {
  Console.log("🌀 Phantom Metal Taste - Initializing (ReScript + Deno)")
  Console.log("━"->Js.String2.repeat(60))

  // Get configuration
  let arangoConfig = Config.getArangoConfig()
  let virtuosoConfig = Config.getVirtuosoConfig()
  let port = Config.getPort()

  try {
    // Initialize ArangoDB
    Console.log("📊 Connecting to ArangoDB...")
    let arangoDB = ArangoDb.create(arangoConfig)
    await ArangoDb.initialize(arangoDB)
    Console.log("✓ ArangoDB initialized")

    // Initialize Virtuoso
    Console.log("🕸️  Connecting to Virtuoso...")
    // TODO: Implement Virtuoso connection
    Console.log("✓ Virtuoso initialized (placeholder)")

    Console.log("━"->Js.String2.repeat(60))
    Console.log(`🚀 API Server starting on port ${port->Belt.Int.toString}`)

    // Simple HTTP server using Deno
    Console.log(`✓ Server would run at http://localhost:${port->Belt.Int.toString}`)
    Console.log("━"->Js.String2.repeat(60))
    Console.log("📍 Key endpoints:")
    Console.log("   GET  /health")
    Console.log("   POST /api/initiatives")
    Console.log("   GET  /api/analytics/gap/:id")
    Console.log("   GET  /api/analytics/gameable-metrics")
    Console.log("   GET  /api/analytics/metric-theater")
    Console.log("   GET  /api/reflection")
    Console.log("━"->Js.String2.repeat(60))
    Console.log("💭 \"The best way to critique a system is to build a rigorous model of it.\"")
    Console.log("━"->Js.String2.repeat(60))
  } catch {
  | Js.Exn.Error(e) => {
      Console.error("❌ Initialization failed:")
      Console.error(e)
      %raw("Deno.exit(1)")
    }
  }
}

// Run main
let _ = main()

// Database configuration types
type arangoConfig = {
  url: string,
  database: string,
  username: string,
  password: string,
}

type virtuosoConfig = {
  queryUrl: string,
  updateUrl: string,
  username: string,
  password: string,
  defaultGraph: string,
}

// Get configuration from environment
let getArangoConfig = (): arangoConfig => {
  url: Deno.env.get("ARANGO_URL")->Belt.Option.getWithDefault("http://localhost:8529"),
  database: Deno.env.get("ARANGO_DATABASE")->Belt.Option.getWithDefault("phantom_metal_taste"),
  username: Deno.env.get("ARANGO_USERNAME")->Belt.Option.getWithDefault("root"),
  password: Deno.env.get("ARANGO_PASSWORD")->Belt.Option.getWithDefault("phantom-dev-password"),
}

let getVirtuosoConfig = (): virtuosoConfig => {
  queryUrl: Deno.env.get("VIRTUOSO_URL")->Belt.Option.getWithDefault(
    "http://localhost:8890/sparql",
  ),
  updateUrl: Deno.env.get("VIRTUOSO_UPDATE_URL")->Belt.Option.getWithDefault(
    "http://localhost:8890/sparql-auth",
  ),
  username: Deno.env.get("VIRTUOSO_USERNAME")->Belt.Option.getWithDefault("dba"),
  password: Deno.env.get("VIRTUOSO_PASSWORD")->Belt.Option.getWithDefault(
    "phantom-dev-password",
  ),
  defaultGraph: Deno.env.get("VIRTUOSO_GRAPH")->Belt.Option.getWithDefault(
    "http://phantom-metal-taste.org/graph",
  ),
}

let getPort = (): int => {
  Deno.env.get("PORT")
  ->Belt.Option.flatMap(Belt.Int.fromString)
  ->Belt.Option.getWithDefault(3000)
}

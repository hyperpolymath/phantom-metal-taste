// ArangoDB connection and operations

// External bindings for ArangoDB operations via fetch
@val external fetch: (string, 'options) => promise<'response> = "fetch"

type arangoResponse<'a> = {
  error: bool,
  result: option<'a>,
  code: int,
}

type database = {
  url: string,
  dbName: string,
  auth: string, // Base64 encoded "username:password"
}

// Initialize connection
let create = (config: Config.arangoConfig): database => {
  let auth = Btoa.btoa(`${config.username}:${config.password}`)
  {
    url: config.url,
    dbName: config.database,
    auth: auth,
  }
}

// Create database if it doesn't exist
let initialize = async (db: database): promise<unit> => {
  // Check if database exists
  let listUrl = `${db.url}/_api/database`
  let headers = {
    "Authorization": `Basic ${db.auth}`,
    "Content-Type": "application/json",
  }

  let response = await fetch(
    listUrl,
    {
      method: "GET",
      headers: headers,
    },
  )

  let data = await response->Response.json
  let databases = data["result"]->Belt.Array.getExn(0)

  let exists = databases->Js.Array2.includes(db.dbName)

  if !exists {
    // Create database
    let createUrl = `${db.url}/_api/database`
    let body = Js.Dict.empty()
    Js.Dict.set(body, "name", Js.Json.string(db.dbName))

    let _ = await fetch(
      createUrl,
      {
        method: "POST",
        headers: headers,
        body: Js.Json.stringify(Js.Json.object_(body)),
      },
    )

    Js.Console.log(`✓ Created database: ${db.dbName}`)
  }

  // Initialize collections
  await initializeCollections(db)
  await initializeGraphs(db)
}

// Initialize collections
and initializeCollections = async (db: database): promise<unit> => {
  let collections = [
    // Vertex collections
    ("initiatives", "document"),
    ("outcomes", "document"),
    ("employees", "document"),
    ("metrics", "document"),
    ("departments", "document"),
    ("events", "document"),
    // Edge collections
    ("causes", "edge"),
    ("participates_in", "edge"),
    ("measures", "edge"),
    ("belongs_to", "edge"),
    ("influences", "edge"),
  ]

  let headers = {
    "Authorization": `Basic ${db.auth}`,
    "Content-Type": "application/json",
  }

  for (name, collType) in collections {
    let checkUrl = `${db.url}/_db/${db.dbName}/_api/collection/${name}`

    let checkResponse = await fetch(checkUrl, {method: "GET", headers: headers})

    if checkResponse.status == 404 {
      let createUrl = `${db.url}/_db/${db.dbName}/_api/collection`
      let body = Js.Dict.empty()
      Js.Dict.set(body, "name", Js.Json.string(name))
      Js.Dict.set(
        body,
        "type",
        Js.Json.number(collType == "edge" ? 3.0 : 2.0),
      )

      let _ = await fetch(
        createUrl,
        {
          method: "POST",
          headers: headers,
          body: Js.Json.stringify(Js.Json.object_(body)),
        },
      )

      Js.Console.log(`✓ Created collection: ${name}`)
    }
  }
}

// Initialize graphs
and initializeGraphs = async (db: database): promise<unit> => {
  let graphName = "causal_graph"
  let headers = {
    "Authorization": `Basic ${db.auth}`,
    "Content-Type": "application/json",
  }

  let checkUrl = `${db.url}/_db/${db.dbName}/_api/gharial/${graphName}`
  let checkResponse = await fetch(checkUrl, {method: "GET", headers: headers})

  if checkResponse.status == 404 {
    let createUrl = `${db.url}/_db/${db.dbName}/_api/gharial`

    let edgeDefinitions = [
      {
        "collection": "causes",
        "from": ["initiatives", "events", "metrics"],
        "to": ["outcomes", "events", "metrics"],
      },
      {
        "collection": "participates_in",
        "from": ["employees"],
        "to": ["initiatives", "events"],
      },
      {
        "collection": "measures",
        "from": ["metrics"],
        "to": ["employees", "departments", "outcomes"],
      },
      {
        "collection": "belongs_to",
        "from": ["employees"],
        "to": ["departments"],
      },
      {
        "collection": "influences",
        "from": ["initiatives", "metrics"],
        "to": ["employees", "departments"],
      },
    ]

    let body = Js.Dict.empty()
    Js.Dict.set(body, "name", Js.Json.string(graphName))
    Js.Dict.set(body, "edgeDefinitions", Js.Json.array(edgeDefinitions))

    let _ = await fetch(
      createUrl,
      {
        method: "POST",
        headers: headers,
        body: Js.Json.stringify(Js.Json.object_(body)),
      },
    )

    Js.Console.log(`✓ Created graph: ${graphName}`)
  }
}

// Execute AQL query
let query = async (db: database, aql: string, bindVars: option<Js.Dict.t<Js.Json.t>>): promise<
  array<Js.Json.t>,
> => {
  let url = `${db.url}/_db/${db.dbName}/_api/cursor`
  let headers = {
    "Authorization": `Basic ${db.auth}`,
    "Content-Type": "application/json",
  }

  let body = Js.Dict.empty()
  Js.Dict.set(body, "query", Js.Json.string(aql))

  switch bindVars {
  | Some(vars) => Js.Dict.set(body, "bindVars", Js.Json.object_(vars))
  | None => ()
  }

  let response = await fetch(
    url,
    {
      method: "POST",
      headers: headers,
      body: Js.Json.stringify(Js.Json.object_(body)),
    },
  )

  let data = await response->Response.json
  data["result"]->Belt.Option.getWithDefault([])
}

// Save document to collection
let save = async (
  db: database,
  collection: string,
  document: Js.Dict.t<Js.Json.t>,
): promise<Js.Json.t> => {
  let url = `${db.url}/_db/${db.dbName}/_api/document/${collection}`
  let headers = {
    "Authorization": `Basic ${db.auth}`,
    "Content-Type": "application/json",
  }

  let response = await fetch(
    url,
    {
      method: "POST",
      headers: headers,
      body: Js.Json.stringify(Js.Json.object_(document)),
    },
  )

  await response->Response.json
}

// Get document by key
let get = async (db: database, collection: string, key: string): promise<option<Js.Json.t>> => {
  let url = `${db.url}/_db/${db.dbName}/_api/document/${collection}/${key}`
  let headers = {
    "Authorization": `Basic ${db.auth}`,
  }

  let response = await fetch(url, {method: "GET", headers: headers})

  if response.status == 200 {
    let data = await response->Response.json
    Some(data)
  } else {
    None
  }
}

// Truncate collection
let truncate = async (db: database, collection: string): promise<unit> => {
  let url = `${db.url}/_db/${db.dbName}/_api/collection/${collection}/truncate`
  let headers = {
    "Authorization": `Basic ${db.auth}`,
  }

  let _ = await fetch(url, {method: "PUT", headers: headers})
  ()
}

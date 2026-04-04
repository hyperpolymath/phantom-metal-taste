// External JavaScript bindings for Deno and browser APIs

// Deno namespace
module Deno = {
  module Env = {
    @val @scope("Deno.env")
    external get: string => option<string> = "get"
  }
}

// Response type
module Response = {
  type t

  @send external json: t => promise<Js.Json.t> = "json"
  @send external text: t => promise<string> = "text"
  @get external status: t => int = "status"
  @get external ok: t => bool = "ok"
}

// Fetch options
type fetchOptions = {
  method: string,
  headers: Js.Dict.t<string>,
  body: option<string>,
}

@val
external fetch: (string, fetchOptions) => promise<Response.t> = "fetch"

// Base64 encoding
module Btoa = {
  @val external btoa: string => string = "btoa"
  @val external atob: string => string = "atob"
}

// Console
module Console = {
  @val @scope("console") external log: 'a => unit = "log"
  @val @scope("console") external error: 'a => unit = "error"
  @val @scope("console") external warn: 'a => unit = "warn"
}

// Promise utilities
@val
external promiseAll: array<promise<'a>> => promise<array<'a>> = "Promise.all"

// Date
module Date = {
  type t
  @new external make: unit => t = "Date"
  @send external toISOString: t => string = "toISOString"
}

// JSON utilities
module Json = {
  @val @scope("JSON")
  external stringify: Js.Json.t => string = "stringify"

  @val @scope("JSON")
  external parse: string => Js.Json.t = "parse"
}

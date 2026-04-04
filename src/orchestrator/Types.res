// Type definitions for the domain model

type initiativeStatus = Planned | Active | Completed | Abandoned

type outcomeType = Intended | Unintended | Emergent

type metricType = Wellness | Productivity | Engagement | Synergy | Custom

type causalLinkType = Direct | Indirect | Spurious

// Core domain types
type initiative = {
  key: option<string>,
  id: option<string>,
  name: string,
  description: string,
  startDate: string,
  endDate: option<string>,
  department: string,
  intendedOutcome: string,
  budget: option<float>,
  participants: array<string>,
  status: initiativeStatus,
  metadata: option<Js.Dict.t<Js.Json.t>>,
}

type outcome = {
  key: option<string>,
  id: option<string>,
  description: string,
  timestamp: string,
  outcomeType: outcomeType,
  severity: int,
  measuredBy: array<string>,
  affectedEmployees: array<string>,
  metadata: option<Js.Dict.t<Js.Json.t>>,
}

type employee = {
  key: option<string>,
  id: option<string>,
  employeeId: string,
  name: string,
  email: string,
  department: string,
  role: string,
  hireDate: string,
  wellnessScore: option<float>,
  engagementLevel: option<float>,
  synergized: bool,
  metadata: option<Js.Dict.t<Js.Json.t>>,
}

type metric = {
  key: option<string>,
  id: option<string>,
  name: string,
  description: string,
  metricType: metricType,
  value: float,
  timestamp: string,
  unit: option<string>,
  target: option<float>,
  actualVsTarget: option<float>,
  collectedBy: option<string>,
  metadata: option<Js.Dict.t<Js.Json.t>>,
}

type department = {
  key: option<string>,
  id: option<string>,
  name: string,
  description: string,
  headOfDepartment: option<string>,
  employeeCount: int,
  budget: option<float>,
  synergyIndex: option<float>,
  metadata: option<Js.Dict.t<Js.Json.t>>,
}

type causalLink = {
  key: option<string>,
  id: option<string>,
  from: string,
  to: string,
  strength: float,
  linkType: causalLinkType,
  evidence: array<string>,
  discoveredAt: string,
  metadata: option<Js.Dict.t<Js.Json.t>>,
}

// Analysis results
type intentionRealityGap = {
  initiativeId: string,
  initiativeName: string,
  intendedOutcome: string,
  actualOutcomes: array<outcome>,
  gapScore: float,
  unintendedConsequences: array<outcome>,
  analysis: string,
  recommendations: option<array<string>>,
}

type causalPathNode = {
  node: string,
  nodeType: string,
  label: option<string>,
}

type causalPath = {
  from: string,
  to: string,
  path: array<causalPathNode>,
  totalStrength: float,
  length: int,
}

// Helper functions for type conversions
let statusToString = (status: initiativeStatus): string =>
  switch status {
  | Planned => "planned"
  | Active => "active"
  | Completed => "completed"
  | Abandoned => "abandoned"
  }

let statusFromString = (s: string): option<initiativeStatus> =>
  switch s {
  | "planned" => Some(Planned)
  | "active" => Some(Active)
  | "completed" => Some(Completed)
  | "abandoned" => Some(Abandoned)
  | _ => None
  }

let outcomeTypeToString = (ot: outcomeType): string =>
  switch ot {
  | Intended => "intended"
  | Unintended => "unintended"
  | Emergent => "emergent"
  }

let outcomeTypeFromString = (s: string): option<outcomeType> =>
  switch s {
  | "intended" => Some(Intended)
  | "unintended" => Some(Unintended)
  | "emergent" => Some(Emergent)
  | _ => None
  }

let metricTypeToString = (mt: metricType): string =>
  switch mt {
  | Wellness => "wellness"
  | Productivity => "productivity"
  | Engagement => "engagement"
  | Synergy => "synergy"
  | Custom => "custom"
  }

let metricTypeFromString = (s: string): option<metricType> =>
  switch s {
  | "wellness" => Some(Wellness)
  | "productivity" => Some(Productivity)
  | "engagement" => Some(Engagement)
  | "synergy" => Some(Synergy)
  | "custom" => Some(Custom)
  | _ => None
  }

let causalLinkTypeToString = (clt: causalLinkType): string =>
  switch clt {
  | Direct => "direct"
  | Indirect => "indirect"
  | Spurious => "spurious"
  }

let causalLinkTypeFromString = (s: string): option<causalLinkType> =>
  switch s {
  | "direct" => Some(Direct)
  | "indirect" => Some(Indirect)
  | "spurious" => Some(Spurious)
  | _ => None
  }

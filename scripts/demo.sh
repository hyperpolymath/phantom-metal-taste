#!/usr/bin/env bash
# SPDX-License-Identifier: MPL-2.0
# SPDX-FileCopyrightText: 2026 Jonathan D.A. Jewell (hyperpolymath) <j.d.a.jewell@open.ac.uk>
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$root"

if ! command -v julia >/dev/null 2>&1; then
  printf 'Julia is not installed. Run `mise install` or follow docs/SETUP.adoc.\n' >&2
  exit 127
fi

julia --project=. -e '
using PhantomAnalytics
using JSON3

impact = PhantomAnalytics.ImpactAnalysis
causal = PhantomAnalytics.CausalInference

intention = Float64[100, 100, 100, 100]
actual = Float64[110, 112, 108, 115]
println("Intention/reality gap:")
println(JSON3.write(impact.analyze_intention_reality_gap(intention, actual)))

series = Float64[10, 10, 11, 10, 12, 10, 11, 15, 16, 16, 17, 18, 19, 20]
println("\nMetric-gaming signals:")
println(JSON3.write(impact.detect_metric_gaming(series; window_size=7)))

treatment = Float64[0, 1, 0, 1, 0, 1]
confounder = Float64[0, 0, 1, 1, 2, 2]
noise = Float64[0.0, 0.1, -0.1, 0.1, -0.1, 0.0]
outcome = 5.0 .+ 2.0 .* treatment .+ 3.0 .* confounder .+ noise
println("\nIllustrative adjusted treatment estimate:")
println(JSON3.write(causal.estimate_causal_effect(treatment, outcome, reshape(confounder, :, 1))))
'

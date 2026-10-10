# SPDX-License-Identifier: MPL-2.0
# SPDX-FileCopyrightText: 2026 Jonathan D.A. Jewell (hyperpolymath) <j.d.a.jewell@open.ac.uk>
"""
    PhantomAnalytics

Experimental statistical analysis functions for the Phantom Metal Taste project.
The API and results remain prototypes; this package does not expose an HTTP
service or connect to the optional database containers.
"""
module PhantomAnalytics

module ImpactAnalysis
include("analytics/impact_analysis.jl")
end

module CausalInference
include("analytics/causal_inference.jl")
end

export ImpactAnalysis, CausalInference

end

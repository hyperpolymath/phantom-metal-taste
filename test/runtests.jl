# SPDX-License-Identifier: MPL-2.0
# SPDX-FileCopyrightText: 2026 Jonathan D.A. Jewell (hyperpolymath) <j.d.a.jewell@open.ac.uk>
using PhantomAnalytics
using Test

const Impact = PhantomAnalytics.ImpactAnalysis
const Causal = PhantomAnalytics.CausalInference

@testset "impact analysis" begin
    gap = Impact.analyze_intention_reality_gap(
        Float64[100, 100, 100, 100],
        Float64[110, 112, 108, 115],
    )
    @test 0.0 <= gap["phantom_score"] <= 100.0
    @test gap["gap_mean"] > 0.0
    @test_throws ArgumentError Impact.analyze_intention_reality_gap(Float64[1], Float64[1, 2])

    short = Impact.detect_metric_gaming(Float64[1, 2, 3])
    @test short["gaming_probability"] == 0.0
    @test short["reason"] == "Insufficient data"

    index = Impact.calculate_organizational_delusion_index(2, 4, 1, 12.0, 0.2)
    @test 0.0 <= index["organizational_delusion_index"] <= 100.0
    @test startswith(index["grade"], "A") || startswith(index["grade"], "B") ||
          startswith(index["grade"], "C") || startswith(index["grade"], "D") ||
          startswith(index["grade"], "F")
end

@testset "causal analysis" begin
    treatment = Float64[0, 1, 0, 1, 0, 1]
    confounder = Float64[0, 0, 1, 1, 2, 2]
    noise = Float64[0.0, 0.1, -0.1, 0.1, -0.1, 0.0]
    outcome = 5.0 .+ 2.0 .* treatment .+ 3.0 .* confounder .+ noise
    estimate = Causal.estimate_causal_effect(treatment, outcome, reshape(confounder, :, 1))
    @test estimate["causal_estimate"] ≈ 2.0 atol=0.2
    @test length(estimate["confidence_interval_95"]) == 2

    spurious = Causal.detect_spurious_correlation(
        Float64[1, 2, 3, 5, 6],
        Float64[2, 1, 4, 3, 7],
        Float64[5, 3, 4, 1, 2],
    )
    @test haskey(spurious, "partial_correlation_xy_given_z")
end

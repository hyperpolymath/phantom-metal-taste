#!/usr/bin/env julia

"""
Impact Analysis Module for Phantom Metal Taste

Performs sophisticated statistical analysis on organizational metrics to detect
anomalies, gaming, and the gap between stated intentions and actual outcomes.

The irony: Using rigorous statistical methods to measure the unmeasurable.
"""

using Statistics
using StatsBase
using Distributions
using LinearAlgebra
using JSON3

"""
    analyze_intention_reality_gap(intended_metrics, actual_metrics)

Calculate the statistical significance of the gap between intended and actual outcomes.
Uses Bayesian inference to estimate the probability that the gap is meaningful vs. noise.
"""
function analyze_intention_reality_gap(intended::Vector{Float64}, actual::Vector{Float64})
    if length(intended) != length(actual)
        throw(ArgumentError("Intended and actual metric vectors must have same length"))
    end

    gaps = abs.(actual .- intended)

    # Calculate gap statistics
    gap_mean = mean(gaps)
    gap_std = std(gaps)
    gap_median = median(gaps)

    # Relative gap (normalized by intended values)
    relative_gaps = gaps ./ (abs.(intended) .+ 1e-10)  # Add epsilon to avoid division by zero
    mean_relative_gap = mean(relative_gaps)

    # Detection of systematic bias (are we consistently over or under?)
    differences = actual .- intended
    bias_direction = sign(mean(differences))
    bias_magnitude = abs(mean(differences))

    # Calculate statistical significance using t-test
    # H0: gap = 0, H1: gap ≠ 0
    n = length(gaps)
    t_statistic = gap_mean / (gap_std / sqrt(n))

    # Critical value for 95% confidence (two-tailed)
    critical_value = quantile(TDist(n-1), 0.975)
    is_significant = abs(t_statistic) > critical_value

    # Calculate "phantom score" - proprietary metric
    # Higher score = bigger gap between intention and reality
    phantom_score = min(100.0, mean_relative_gap * 100)

    return Dict(
        "gap_mean" => gap_mean,
        "gap_std" => gap_std,
        "gap_median" => gap_median,
        "mean_relative_gap_percent" => mean_relative_gap * 100,
        "bias_direction" => bias_direction,
        "bias_magnitude" => bias_magnitude,
        "t_statistic" => t_statistic,
        "is_statistically_significant" => is_significant,
        "phantom_score" => phantom_score,
        "interpretation" => interpret_phantom_score(phantom_score)
    )
end

"""
    detect_metric_gaming(time_series; window_size=7)

Detect gaming patterns in metric time series.
Looks for:
- Sudden improvements that don't match underlying trends
- Suspiciously low variance
- End-of-period spikes
- Too-perfect alignment with targets
"""
function detect_metric_gaming(values::Vector{Float64}; window_size::Int=7)
    n = length(values)

    if n < window_size
        return Dict("gaming_probability" => 0.0, "reason" => "Insufficient data")
    end

    gaming_signals = Float64[]

    # 1. Check variance (too consistent = suspicious)
    variance = var(values)
    mean_val = mean(values)
    coef_variation = sqrt(variance) / (abs(mean_val) + 1e-10)

    if coef_variation < 0.05  # Less than 5% variation
        push!(gaming_signals, 0.3)
    end

    # 2. Check for end-of-period spikes
    if n >= window_size * 2
        end_period_mean = mean(values[end-window_size+1:end])
        earlier_mean = mean(values[1:end-window_size])

        if end_period_mean > earlier_mean * 1.3  # 30% spike
            push!(gaming_signals, 0.25)
        end
    end

    # 3. Check for too-perfect target alignment
    # Assume target is around mean of upper quartile
    target_estimate = quantile(values, 0.75)
    near_target = count(v -> abs(v - target_estimate) < 0.02 * target_estimate, values)

    if near_target / n > 0.6  # More than 60% clustered near target
        push!(gaming_signals, 0.25)
    end

    # 4. Check for sudden discontinuities
    if n >= 3
        diffs = diff(values)
        large_jumps = count(d -> abs(d) > 2 * std(diffs), diffs)

        if large_jumps / length(diffs) > 0.2  # More than 20% are large jumps
            push!(gaming_signals, 0.2)
        end
    end

    gaming_probability = min(1.0, sum(gaming_signals))

    return Dict(
        "gaming_probability" => gaming_probability,
        "confidence_level" => gaming_probability > 0.7 ? "HIGH" : (gaming_probability > 0.4 ? "MODERATE" : "LOW"),
        "variance" => variance,
        "coefficient_of_variation" => coef_variation,
        "signals_detected" => length(gaming_signals),
        "verdict" => gaming_probability > 0.6 ? "Gaming suspected" : "Appears legitimate"
    )
end

"""
    calculate_organizational_delusion_index(initiatives_data)

Calculate an aggregate measure of organizational self-deception.
Combines multiple signals into a single index.
"""
function calculate_organizational_delusion_index(
    n_initiatives::Int,
    n_intended_outcomes::Int,
    n_unintended_outcomes::Int,
    avg_metric_gap::Float64,
    gaming_probability::Float64
)
    # Weight factors
    outcome_ratio = n_unintended_outcomes / max(n_intended_outcomes, 1)

    # Components of delusion (each 0-100)
    outcome_delusion = min(100, outcome_ratio * 50)  # Unintended vs intended
    metric_delusion = min(100, avg_metric_gap)  # How far off metrics are
    gaming_delusion = gaming_probability * 100  # Probability of gaming

    # Aggregate with weights
    delusion_index = (
        outcome_delusion * 0.4 +
        metric_delusion * 0.3 +
        gaming_delusion * 0.3
    )

    return Dict(
        "organizational_delusion_index" => delusion_index,
        "grade" => grade_delusion(delusion_index),
        "outcome_delusion_score" => outcome_delusion,
        "metric_delusion_score" => metric_delusion,
        "gaming_delusion_score" => gaming_delusion,
        "interpretation" => interpret_delusion(delusion_index),
        "recommendation" => recommend_intervention(delusion_index)
    )
end

"""
    correlation_analysis(metric_values, outcome_values)

Analyze correlation between metrics and actual outcomes.
Low correlation suggests "metric theater" - measuring things that don't matter.
"""
function correlation_analysis(metrics::Vector{Float64}, outcomes::Vector{Float64})
    if length(metrics) != length(outcomes)
        throw(ArgumentError("Metric and outcome vectors must have same length"))
    end

    if length(metrics) < 3
        return Dict("error" => "Insufficient data points")
    end

    # Pearson correlation
    r = cor(metrics, outcomes)

    # Coefficient of determination
    r_squared = r^2

    # Fisher transformation for significance testing
    n = length(metrics)
    fisher_z = 0.5 * log((1 + r) / (1 - r))
    se_fisher = 1 / sqrt(n - 3)

    # Test if correlation is significantly different from zero
    z_score = fisher_z / se_fisher
    p_value = 2 * (1 - cdf(Normal(), abs(z_score)))

    is_significant = p_value < 0.05

    # Theater score: high if metrics don't correlate with outcomes
    theater_score = is_significant ? (1 - abs(r)) * 100 : 50.0

    return Dict(
        "correlation_coefficient" => r,
        "r_squared" => r_squared,
        "p_value" => p_value,
        "is_significant" => is_significant,
        "metric_theater_score" => theater_score,
        "interpretation" => interpret_correlation(r, is_significant),
        "warning" => theater_score > 70 ? "HIGH METRIC THEATER DETECTED" : nothing
    )
end

# Helper functions for interpretation

function interpret_phantom_score(score::Float64)
    if score > 75
        "Severe divergence - stated intentions and reality are fundamentally misaligned"
    elseif score > 50
        "Significant gap - intentions and outcomes show substantial divergence"
    elseif score > 25
        "Moderate gap - some divergence between intention and reality"
    else
        "Minimal gap - intentions and outcomes are reasonably aligned"
    end
end

function grade_delusion(index::Float64)
    if index > 80
        "F - Critical organizational delusion"
    elseif index > 60
        "D - Severe self-deception detected"
    elseif index > 40
        "C - Moderate reality distortion"
    elseif index > 20
        "B - Slight optimism bias"
    else
        "A - Relatively realistic"
    end
end

function interpret_delusion(index::Float64)
    if index > 80
        "Organization shows critical disconnect from reality. Measurements and outcomes are fundamentally misaligned."
    elseif index > 60
        "Significant organizational delusion detected. Consider fundamental reassessment of goals and metrics."
    elseif index > 40
        "Moderate reality distortion. Some initiatives are producing unexpected consequences."
    else
        "Organization shows reasonable alignment between stated goals and actual outcomes."
    end
end

function recommend_intervention(index::Float64)
    if index > 80
        "URGENT: Stop all metric collection for 30 days. Conduct ethnographic study of actual work patterns."
    elseif index > 60
        "Recommended: External audit of metric validity. Anonymous employee feedback on metric gaming."
    elseif index > 40
        "Suggested: Review and simplify metric collection. Focus on outcomes over outputs."
    else
        "Maintain current approach with regular validation checks."
    end
end

function interpret_correlation(r::Float64, significant::Bool)
    if !significant
        "No significant correlation - metrics may not be measuring what matters"
    elseif abs(r) > 0.7
        r > 0 ? "Strong positive correlation - metrics align with outcomes" :
                "Strong negative correlation - metrics may be inversely related to success"
    elseif abs(r) > 0.4
        "Moderate correlation - some relationship exists but with substantial noise"
    else
        "Weak correlation - possible metric theater"
    end
end

# CLI interface for standalone execution
function main(args::Vector{String})
    if length(args) < 2
        println("""
        Usage: julia impact_analysis.jl <command> <json_data>

        Commands:
          gap         - Analyze intention-reality gap
          gaming      - Detect metric gaming
          delusion    - Calculate organizational delusion index
          correlation - Analyze metric-outcome correlation
        """)
        return
    end

    command = args[1]
    data = JSON3.read(args[2])

    result = if command == "gap"
        analyze_intention_reality_gap(data.intended, data.actual)
    elseif command == "gaming"
        detect_metric_gaming(data.values)
    elseif command == "delusion"
        calculate_organizational_delusion_index(
            data.n_initiatives,
            data.n_intended,
            data.n_unintended,
            data.avg_gap,
            data.gaming_prob
        )
    elseif command == "correlation"
        correlation_analysis(data.metrics, data.outcomes)
    else
        Dict("error" => "Unknown command: $command")
    end

    println(JSON3.write(result))
end

# Run if executed directly
if abspath(PROGRAM_FILE) == @__FILE__
    main(ARGS)
end

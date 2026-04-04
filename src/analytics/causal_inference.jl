#!/usr/bin/env julia

"""
Causal Inference Module

Attempts to infer causality from observational data.
Because correlation ≠ causation, but we're going to try anyway.
"""

using Statistics
using LinearAlgebra
using JSON3

"""
    estimate_causal_effect(treatment, outcome, confounders)

Estimate causal effect of treatment on outcome while controlling for confounders.
Uses a simple linear regression approach (propensity score matching would be better,
but this is a demo).
"""
function estimate_causal_effect(
    treatment::Vector{Float64},
    outcome::Vector{Float64},
    confounders::Matrix{Float64}
)
    n = length(treatment)

    # Build design matrix: [intercept, treatment, confounders...]
    X = hcat(ones(n), treatment, confounders)

    # Ordinary least squares: β = (X'X)^(-1) X'y
    β = (X' * X) \ (X' * outcome)

    # Treatment effect is β[2] (second coefficient)
    causal_estimate = β[2]

    # Calculate residuals and standard error
    y_pred = X * β
    residuals = outcome .- y_pred
    mse = sum(residuals.^2) / (n - size(X, 2))
    var_beta = mse * inv(X' * X)
    se_treatment = sqrt(var_beta[2, 2])

    # Confidence interval (95%)
    ci_lower = causal_estimate - 1.96 * se_treatment
    ci_upper = causal_estimate + 1.96 * se_treatment

    # R-squared
    ss_total = sum((outcome .- mean(outcome)).^2)
    ss_residual = sum(residuals.^2)
    r_squared = 1 - (ss_residual / ss_total)

    return Dict(
        "causal_estimate" => causal_estimate,
        "standard_error" => se_treatment,
        "confidence_interval_95" => [ci_lower, ci_upper],
        "r_squared" => r_squared,
        "is_significant" => !(ci_lower <= 0 <= ci_upper),  # CI doesn't include zero
        "interpretation" => interpret_causal_effect(causal_estimate, ci_lower, ci_upper)
    )
end

"""
    detect_spurious_correlation(x, y, z)

Detect if correlation between x and y is spurious (both caused by z).
"""
function detect_spurious_correlation(x::Vector{Float64}, y::Vector{Float64}, z::Vector{Float64})
    # Correlation between x and y
    r_xy = cor(x, y)

    # Partial correlation controlling for z
    r_xz = cor(x, z)
    r_yz = cor(y, z)

    # Partial correlation formula
    r_xy_given_z = (r_xy - r_xz * r_yz) / sqrt((1 - r_xz^2) * (1 - r_yz^2))

    # If partial correlation is much smaller, likely spurious
    spuriousness_index = abs(r_xy - r_xy_given_z)
    is_spurious = spuriousness_index > 0.5

    return Dict(
        "correlation_xy" => r_xy,
        "partial_correlation_xy_given_z" => r_xy_given_z,
        "spuriousness_index" => spuriousness_index,
        "is_likely_spurious" => is_spurious,
        "verdict" => is_spurious ?
            "Likely spurious - correlation disappears when controlling for confound" :
            "Appears genuine - correlation persists after controlling"
    )
end

"""
    calculate_attribution(initiative_features, outcome_severity)

Attribute outcome severity to initiative features.
Helps answer: "Which aspects of this initiative caused the bad outcome?"
"""
function calculate_attribution(
    feature_matrix::Matrix{Float64},
    feature_names::Vector{String},
    outcome::Vector{Float64}
)
    n_features = size(feature_matrix, 2)

    # Standardize features
    feature_means = mean(feature_matrix, dims=1)
    feature_stds = std(feature_matrix, dims=1)
    X_std = (feature_matrix .- feature_means) ./ (feature_stds .+ 1e-10)

    # Fit model
    X = hcat(ones(size(X_std, 1)), X_std)
    β = (X' * X) \ (X' * outcome)

    # Attribution = absolute value of standardized coefficients
    attributions = abs.(β[2:end])  # Skip intercept

    # Normalize to percentages
    total = sum(attributions)
    percentages = (attributions ./ total) .* 100

    # Rank features
    ranked_indices = sortperm(percentages, rev=true)

    attributions_dict = [
        Dict(
            "feature" => feature_names[i],
            "attribution_percent" => percentages[i],
            "coefficient" => β[i+1],
            "direction" => β[i+1] > 0 ? "increases" : "decreases"
        )
        for i in ranked_indices
    ]

    return Dict(
        "attributions" => attributions_dict,
        "most_influential" => feature_names[ranked_indices[1]],
        "least_influential" => feature_names[ranked_indices[end]]
    )
end

function interpret_causal_effect(estimate::Float64, ci_lower::Float64, ci_upper::Float64)
    if ci_lower <= 0 <= ci_upper
        return "No significant causal effect detected (CI includes zero)"
    elseif estimate > 0
        return "Positive causal effect: treatment increases outcome by $(round(estimate, digits=2)) units (95% CI: [$(round(ci_lower, digits=2)), $(round(ci_upper, digits=2))])"
    else
        return "Negative causal effect: treatment decreases outcome by $(round(abs(estimate), digits=2)) units (95% CI: [$(round(ci_lower, digits=2)), $(round(ci_upper, digits=2))])"
    end
end

# CLI interface
function main(args::Vector{String})
    if length(args) < 2
        println("""
        Usage: julia causal_inference.jl <command> <json_data>

        Commands:
          estimate    - Estimate causal effect
          spurious    - Detect spurious correlation
          attribute   - Calculate feature attribution
        """)
        return
    end

    command = args[1]
    data = JSON3.read(args[2])

    result = if command == "estimate"
        estimate_causal_effect(
            data.treatment,
            data.outcome,
            reduce(hcat, data.confounders)
        )
    elseif command == "spurious"
        detect_spurious_correlation(data.x, data.y, data.z)
    elseif command == "attribute"
        calculate_attribution(
            reduce(hcat, data.features),
            data.feature_names,
            data.outcome
        )
    else
        Dict("error" => "Unknown command: $command")
    end

    println(JSON3.write(result))
end

if abspath(PROGRAM_FILE) == @__FILE__
    main(ARGS)
end

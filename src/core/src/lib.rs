#![forbid(unsafe_code)]
use wasm_bindgen::prelude::*;
use serde::{Deserialize, Serialize};

#[derive(Serialize, Deserialize, Debug, Clone)]
pub struct MetricGap {
    pub metric_name: String,
    pub target: f64,
    pub actual: f64,
    pub gap: f64,
    pub gap_percentage: f64,
}

#[derive(Serialize, Deserialize, Debug, Clone)]
pub struct CausalStrength {
    pub from: String,
    pub to: String,
    pub strength: f64,
    pub confidence: f64,
}

/// Calculate the intention-reality gap for a set of metrics
/// This is a performance-critical operation that benefits from WASM
#[wasm_bindgen]
pub fn calculate_metric_gaps(metrics_json: &str) -> Result<String, JsValue> {
    let metrics: Vec<(String, f64, f64)> = serde_json::from_str(metrics_json)
        .map_err(|e| JsValue::from_str(&format!("Parse error: {}", e)))?;

    let gaps: Vec<MetricGap> = metrics
        .into_iter()
        .map(|(name, target, actual)| {
            let gap = (actual - target).abs();
            let gap_percentage = if target != 0.0 {
                (gap / target.abs()) * 100.0
            } else {
                100.0
            };

            MetricGap {
                metric_name: name,
                target,
                actual,
                gap,
                gap_percentage,
            }
        })
        .collect();

    serde_json::to_string(&gaps)
        .map_err(|e| JsValue::from_str(&format!("Serialization error: {}", e)))
}

/// Calculate path strength through a causal graph
/// Uses geometric mean to account for weakest links
#[wasm_bindgen]
pub fn calculate_path_strength(edge_strengths: &[f64]) -> f64 {
    if edge_strengths.is_empty() {
        return 0.0;
    }

    let product: f64 = edge_strengths.iter().product();
    product.powf(1.0 / edge_strengths.len() as f64)
}

/// Detect anomalous metric patterns
/// Returns suspicion score (0-100) based on statistical properties
#[wasm_bindgen]
pub fn detect_metric_anomalies(values_json: &str) -> Result<f64, JsValue> {
    let values: Vec<f64> = serde_json::from_str(values_json)
        .map_err(|e| JsValue::from_str(&format!("Parse error: {}", e)))?;

    if values.len() < 3 {
        return Ok(0.0);
    }

    let mean = values.iter().sum::<f64>() / values.len() as f64;
    let variance = values
        .iter()
        .map(|v| (v - mean).powi(2))
        .sum::<f64>() / values.len() as f64;
    let std_dev = variance.sqrt();

    // Check for suspicious patterns
    let mut suspicion: f64 = 0.0;

    // Too consistent (gaming indicator)
    if std_dev < 0.01 * mean.abs() {
        suspicion += 40.0;
    }

    // All values at or near target (too good to be true)
    let near_perfect = values.iter().filter(|&&v| (v - 100.0).abs() < 2.0).count();
    if near_perfect as f64 > values.len() as f64 * 0.8 {
        suspicion += 35.0;
    }

    // Sudden jumps (manipulation indicator)
    let mut jumps = 0;
    for i in 1..values.len() {
        if (values[i] - values[i - 1]).abs() > 20.0 {
            jumps += 1;
        }
    }
    if jumps as f64 > values.len() as f64 * 0.3 {
        suspicion += 25.0;
    }

    Ok(suspicion.min(100.0))
}

/// Calculate synergy score (with maximum irony)
/// The more "optimized" a score looks, the more suspicious it should be
#[wasm_bindgen]
pub fn calculate_synergy_score(
    wellness: f64,
    engagement: f64,
    productivity: f64,
    alignment: f64,
) -> f64 {
    // Simple weighted average
    let raw_score = wellness * 0.25 + engagement * 0.25 + productivity * 0.30 + alignment * 0.20;

    // But if it's too perfect, something's wrong
    let variance = [wellness, engagement, productivity, alignment]
        .iter()
        .map(|&x| (x - raw_score).abs())
        .sum::<f64>()
        / 4.0;

    // Low variance = gaming suspected
    if variance < 5.0 && raw_score > 85.0 {
        raw_score * 0.7 // Penalty for suspiciously uniform excellence
    } else {
        raw_score
    }
}

/// Analyze time series for "metric theater" patterns
/// Returns probability (0-1) that metrics are being gamed
#[wasm_bindgen]
pub fn detect_metric_theater(time_series_json: &str) -> Result<f64, JsValue> {
    #[derive(Deserialize)]
    struct TimePoint {
        timestamp: String,
        value: f64,
        linked_actions: usize,
    }

    let series: Vec<TimePoint> = serde_json::from_str(time_series_json)
        .map_err(|e| JsValue::from_str(&format!("Parse error: {}", e)))?;

    if series.is_empty() {
        return Ok(0.0);
    }

    let total_points = series.len();
    let unlinked_count = series.iter().filter(|p| p.linked_actions == 0).count();
    let unlinked_ratio = unlinked_count as f64 / total_points as f64;

    // High collection rate with low action linkage = theater
    let theater_probability = if total_points > 10 {
        unlinked_ratio * 0.7 + (if unlinked_ratio > 0.8 { 0.3 } else { 0.0 })
    } else {
        unlinked_ratio * 0.5
    };

    Ok(theater_probability.min(1.0))
}

/// Calculate the "phantom metal taste" score
/// The core metric: how wrong does this feel?
#[wasm_bindgen]
pub fn phantom_metal_taste_score(
    intended_outcomes: usize,
    actual_outcomes: usize,
    unintended_outcomes: usize,
    avg_metric_gap: f64,
    metric_theater_probability: f64,
) -> f64 {
    let outcome_ratio = if intended_outcomes > 0 {
        unintended_outcomes as f64 / intended_outcomes as f64
    } else {
        2.0 // No intended outcomes measured is very suspicious
    };

    let base_score = outcome_ratio * 30.0 + avg_metric_gap * 30.0 + metric_theater_probability * 40.0;

    // Cap at 100
    base_score.min(100.0)
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_calculate_metric_gaps() {
        let metrics = r#"[["Wellness", 80.0, 95.0], ["Engagement", 70.0, 40.0]]"#;
        let result = calculate_metric_gaps(metrics).unwrap();
        assert!(result.contains("Wellness"));
    }

    #[test]
    fn test_path_strength() {
        let strengths = vec![0.9, 0.8, 0.7];
        let result = calculate_path_strength(&strengths);
        assert!(result > 0.0 && result < 1.0);
    }

    #[test]
    fn test_synergy_gaming_detection() {
        // Perfect scores across the board = suspicious
        let score = calculate_synergy_score(95.0, 95.0, 95.0, 95.0);
        assert!(score < 95.0); // Should be penalized
    }

    #[test]
    fn test_phantom_score() {
        let score = phantom_metal_taste_score(
            5,  // intended
            3,  // actual
            7,  // unintended
            45.0, // avg gap
            0.7,  // theater prob
        );
        assert!(score > 50.0); // Should indicate significant gap
    }
}

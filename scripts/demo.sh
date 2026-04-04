#!/bin/bash

# Demo script for Phantom Metal Taste
# Demonstrates key features of the system

set -e

API_URL="http://localhost:3000"

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Phantom Metal Taste - Interactive Demo"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Check if API is running
echo "🔍 Checking API health..."
if ! curl -s "${API_URL}/health" > /dev/null; then
    echo "API is not running. Please start it with: deno task dev"
    exit 1
fi
echo "✓ API is healthy"
echo ""

# Check if data is loaded
echo "🔍 Checking if SynapCor data is loaded..."
METRIC_COUNT=$(curl -s "${API_URL}/api/analytics/gameable-metrics" | grep -o '"count":[0-9]*' | cut -d: -f2 || echo "0")

if [ "$METRIC_COUNT" -eq "0" ]; then
    echo "⚠️  No data found. Loading SynapCor case study..."
    deno task load-data
else
    echo "✓ Data is loaded"
fi
echo ""

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Demo 1: Detecting Gameable Metrics"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Metrics with large gaps between target and actual values"
echo "suggest either unrealistic targets or gaming behavior."
echo ""
curl -s "${API_URL}/api/analytics/gameable-metrics" | jq '.metrics[] | {name: .metric.name, gap: .gapPercentage, suspicion: .suspicionLevel}'
echo ""

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Demo 2: Metric Theater Detection"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Metrics that are collected but never linked to any initiative"
echo "or decision represent 'metric theater' - measurement for its own sake."
echo ""
curl -s "${API_URL}/api/analytics/metric-theater" | jq '{detected: .detected, message: .message}'
echo ""

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Demo 3: Philosophical Reflection"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Every good system should question its own existence..."
echo ""
curl -s "${API_URL}/api/reflection" | jq '.'
echo ""

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Demo Complete!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Explore more:"
echo "  • API docs: http://localhost:3000/health"
echo "  • ArangoDB: http://localhost:8529"
echo "  • Virtuoso: http://localhost:8890/conductor"
echo ""
echo "Key endpoints:"
echo "  GET  /api/analytics/gameable-metrics"
echo "  GET  /api/analytics/metric-theater"
echo "  GET  /api/analytics/gap/:id"
echo "  GET  /api/reflection"
echo ""

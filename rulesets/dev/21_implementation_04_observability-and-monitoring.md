# Observability and Monitoring

## Metrics
- Instrument critical functionality with your telemetry framework  
  (e.g., OpenTelemetry, Prometheus client libraries, Micrometer).
- Choose metric types appropriately: counters for events, gauges for current state, 
  timers for durations, histograms when distribution matters.
- Use descriptive names (e.g., `rate_limit.requests.allowed`) and include units/labels thoughtfully.
- Where practical, test that expected metrics are emitted in automated tests.

## Logging
- Log important state changes at INFO level; reserve WARN/ERROR for actionable issues.
- Prefer structured logging so fields remain machine-readable across languages and platforms.

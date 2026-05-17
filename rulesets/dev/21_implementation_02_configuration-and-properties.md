# Configuration and Properties

## Configurable Values
- Use framework-appropriate configuration injection (e.g., Spring `@Value`, env vars, or config providers).
- Prefer constructor injection or explicit parameter passing to keep values testable.
- Configure values when testing and production may reasonably differ (e.g., rate-limit capacity lower in tests).
- Do not configure values that should remain the same everywhere.
- Document defaults and make values easy to override for testing.

## Property Naming
- Use kebab-case such as `rate-limit.capacity`.
- Group related properties by prefix.
- Provide sensible defaults.

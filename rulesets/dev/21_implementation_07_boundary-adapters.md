# Boundary Adapters for External Libraries and Protocols

When production code interacts with external libraries, protocols, or transport-specific
payloads, keep those details at a dedicated boundary adapter instead of leaking them through the
application layer.

## Core Rule

- Wrap external libraries behind a small application-owned interface when the library introduces
  protocol-specific types, encoding/decoding rules, or verification semantics.
- Keep transport and protocol details such as Base64 encoding, binary payload parsing, vendor
  exception types, and library-owned request/response models at that boundary.
- The application layer should consume stable, application-owned inputs and outputs whenever
  practical.

## What Belongs at the Boundary

- Library-specific request and response types
- Encoding and decoding logic
- Protocol validation and normalization
- Translation of vendor/parser errors into application-owned exceptions with safe messages

## What Should Stay Out of the Application Layer

- Direct imports of third-party protocol types across multiple files
- Repeated decoding/parsing logic in services or controllers
- Low-level parser, decoder, or library exception messages leaking to HTTP responses

## Design Guidance

- Prefer one boundary module or adapter per external protocol or library family.
- If the application still needs one small protocol-specific step before the adapter call, keep it
  behind a dedicated helper with the same sanitization and translation rules.
- Tests should verify both:
  - the happy-path mapping at the adapter boundary
  - the sanitized failure behavior for malformed external input

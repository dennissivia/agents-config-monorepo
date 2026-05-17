# Testing Standards – Java / Spring Boot

These rules extend the generic testing standards for Java / Spring Boot projects using Maven.

## Test Layers and Expectations

### Unit Tests
- Write unit tests for **all core business logic** (services, domain classes, utility functions).
- Prefer plain JUnit 5 + mocking libraries (e.g., Mockito) **without** starting a Spring context where possible.
- Keep unit tests fast and focused on a single class or behavior.

### Slice and Integration Tests
- Use Spring’s test slices to target specific layers:
  - `@WebMvcTest` for controller/web layer tests.
  - `@DataJpaTest` for JPA repositories and persistence logic.
- Use `@SpringBootTest` (optionally with `webEnvironment = RANDOM_PORT`) for full integration tests that exercise the application end-to-end.
- Tests should cover:
  - controller request/response behavior
  - validation and error handling
  - persistence behavior and transaction boundaries
  - configuration and wiring for critical flows

### Tagging and Speed
- Mark slow or environment-dependent tests with `@Tag("integration")` to keep unit runs fast.
- Quality gates require the full suite (unit + integration) before any
  change-persistence action.

## Test Data Builders and Fixture Wrappers

### Canonical Model
- Use builders as the canonical way to construct test data for domain entities and DTOs.
- Builders should create internally consistent objects with sensible defaults and explicit override methods.
- Builders remain the lowest-level composition primitive; they should model the real domain shape rather than ad-hoc test shortcuts.

### Wrapper Fixtures on Top of Builders
- When tests repeatedly need a realistic object graph (for example account -> member -> checklist -> item), add fixture wrappers or factory helpers on top of the builders.
- These wrappers should hide repetitive dependency wiring while still using builders internally.
- The goal is simple `@BeforeEach` setup and one-call access to valid, production-shaped test data.

### Consistency Requirements
- Test data must preserve the same foreign-key and ownership consistency as production data.
- If a test creates a checklist, the related account/member/identity graph should be valid and reachable through the fixture path rather than invented ad-hoc IDs.
- Prefer saved parent entities and real generated IDs in integration tests.
- In unit tests, prefer rehydration/full-state constructors over mutating private fields.

### Override Strategy
- Builders provide defaults for everything.
- Wrapper fixtures should expose the small set of parameters commonly varied by tests.
- Add more overloads / helper variants incrementally when a new repeated need appears; do not pre-generalize every possible option up front.
- If the wrapper becomes too specialized for broad reuse, keep it local to the test file or package instead of forcing it into a global helper.

### Reflection Policy
- Do not use reflection-based test setup (`setAccessible`, direct field mutation, `ReflectionTestUtils`) when builders, fixture wrappers, save paths, or public rehydration constructors can express the same state.
- Reflection in tests is a last resort for legacy code only, and any new use requires explicit justification.
- If reflection appears repeatedly, that is a signal to add or improve builders/fixture wrappers instead.

## Running the Suites

- The repository's **local validation rules** define the exact commands.
- A typical setup has:
  - a fast/unit-focused suite
  - a full suite that includes integration tests
- If the repository provides a wrapper script for the full suite in `bin/` or `scripts/`,
  local rules may prefer that wrapper over raw Maven commands.

### Environment for Integration Tests
- Integration tests use **Testcontainers** — no external services needed.
- Testcontainers automatically starts a PostgreSQL container per test run.
- Local rules should document any project-specific full-suite wrapper or flags.

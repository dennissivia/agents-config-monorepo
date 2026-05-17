# Implementation Plan Standards

Implementation plans are the primary artifact of the analysis phase. They translate
design documents, ADRs, and codebase analysis into a concrete, step-by-step
specification that guides the implementation phase.

A plan is not ready for implementation until it has been written to the standards below
and cross-reviewed against the project's design documents.

---

## Rule 0: Mandatory Preparation Before Writing

A plan must not be written until this preparation is complete. Skipping it produces
plans that default to generic conventions rather than the project's own standards.

### Step 1 — Read design documentation

Before writing a single line of the plan:

- Read all technical design documents relevant to the area being planned
  (architecture docs, API design, domain model docs).
- Read every ADR that constrains the area — not just the ones that seem obviously
  relevant. An ADR about error handling, null safety, or test architecture may
  apply even when the feature does not look like it touches those areas.

### Step 2 — Explore the relevant code area

Read the full package or module that the planned code will live in or interact with:

- Read adjacent files and sibling classes, not just the single file being changed.
- Read existing analogous services, components, or handlers — ones that do something
  structurally similar to what you are about to build.
- Read the tests for those analogous classes to understand the expected test structure.

### Step 3 — Summarize observed patterns before designing

Before designing anything, produce a brief internal summary of what you observed:

- **Error handling**: How are absent values handled? Optional functional chaining,
  Result types, typed exceptions mapped centrally? What is explicitly forbidden?
- **Type safety**: What boundary types are used? Where are raw maps or untyped
  payloads converted to domain types? Where does null appear and where is it excluded?
- **Abstractions and layering**: What layers exist? What belongs in each? Which
  classes own which responsibilities?
- **Naming and vocabulary**: What terms does the codebase use for the concepts in scope?

This summary is the baseline. Every decision in the plan must be consistent with it.

### Rule: Project ADRs and design documents take precedence over all external conventions

When writing the plan, the project's recorded decisions override any pattern found in:

- Public repositories or tutorials
- Framework documentation defaults
- General "best practice" guides
- Prior experience from other codebases

If the project's ADR says "use Result types," use Result types — even if every public
Spring Boot example uses exceptions. If the project's design doc says "convert raw maps
at the boundary," do not leak the raw map into the service layer — even if that is the
simpler path.

**Error handling and type safety deserve particular scrutiny.** Public examples
frequently omit proper error handling and rely on implicit typing. These are exactly
the areas where the project's own rules are most likely to differ from what an
implementer would default to. Flag these explicitly in the plan.

---

## Rule 1: Writing Standards

Implementation plans describe **what to build and why**, not how to write every line.

### Content Density

- **SQL migrations**: Include verbatim — they ARE the artifact being planned.
- **Configuration files** (YAML, XML, TOML): Include verbatim when the exact shape matters.
- **Domain models**: Field lists (name, type, nullability) and business method signatures.
  Do not include constructor bodies, getter/setter implementations, or boilerplate.
- **Service layer**: Responsibility descriptions and method signatures.
  Do not include method bodies or full implementation logic.
- **Repository interfaces**: Method signatures only.
- **DTOs / API contracts**: Field lists or compact record signatures.
  Do not include full class bodies with annotations and Javadoc.
- **Enums**: Include values — they define domain vocabulary.
- **Exceptions**: Include reason/variant lists. Do not include full class hierarchies.
- **Test plans**: Describe what to test (scenarios, edge cases, layers).
  Do not include full test method implementations.

### Guiding Principle

The diff shows the code. The plan explains the **intent, structure, and decisions**.
If a code block would be identical to what the implementer writes anyway (constructors,
boilerplate, trivial wiring), omit it. If it conveys a non-obvious decision (a specific
SQL constraint, a particular enum set, an unusual method signature), include it.

### What Belongs in a Plan

- Goal, scope, and constraints for the work
- Step-by-step breakdown of deliverables
- Domain model shapes (fields + methods, not bodies)
- API contracts and data flow
- Migration DDL (verbatim)
- Key design decisions and trade-offs
- Test plan (scenarios, not implementations)
- PR checklist / acceptance criteria

### What Does Not Belong

- Full Java/TypeScript class implementations
- Constructor bodies, builder patterns, or wiring code
- Copy-paste-ready code blocks (the plan is not a code generator)
- Implementation details that the existing codebase patterns already dictate

### Snippet Policy: Use Snippets To Enforce, Not To Transcribe

Code snippets in plans are a deliberate tool, not a default. Use them only when
they enforce a decision that prose cannot reliably convey.

**When to include a snippet:**

- A specific framework / security construct where picking the wrong form
  silently breaks the design (e.g., a particular Spring Security matcher form,
  a CSRF cookie repository call, a `@Profile` boundary, an `@Order` annotation).
- A typed boundary contract (e.g., a `@ConfigurationProperties` record signature
  with prefix and validation annotations) that locks in the namespace and
  binding shape.
- A class, interface, or layering anchor that ties to a clean-architecture or
  DDD decision and prevents drift toward a wrong-but-plausible alternative.
- A decision-record-derived constraint where the implementation must follow a
  specific shape, and the decision record alone is not enough to disambiguate.

Snippets in plans should be **minimal**: the smallest fragment that locks in
the decision, not a full class or file body.

**When to skip a snippet:**

- Constructor wiring, getters, builder patterns, generic test scaffolding.
- Full property-file blocks, full deployment-config blocks, full class bodies.
- Method bodies that follow obviously from the signature.
- Anything the implementing agent would write the same way after reading an
  analogous file in the codebase.

Replace such cases with a one-line description plus a pointer to the canonical
example file (e.g., "follow the shape of `HostedSecurityContractIntegrationTest`").

**Always emphasize, even without snippets:**

- The relevant decision records and which decisions they impose. **Decision
  records override existing patterns** when they conflict — say so directly when
  the conflict is plausible.
- The existing patterns the implementation must reuse, and the canonical file
  that demonstrates each.
- "Do this, not that" guidance whenever the wrong-but-plausible pattern would
  compile and pass tests but violate a recorded decision or architectural
  convention.

### Length Target

Single-increment plans should fit comfortably under ~300 lines. If a draft
crosses that line, the question is "what derivable detail can I cut" before
"should this be split."

---

## Rule 2: Cross-Review Before Implementation

An implementation plan must be cross-reviewed before it is considered accurate and ready
for implementation. The review verifies alignment with the project's design documents
and ensures the plan does not introduce contradictions or drift.

### Review Sources

The reviewer must check the plan against:

- **Design documents** (`docs/tech/`) — domain models, architecture, API design
- **ADRs** (`docs/adr/`) — decisions that constrain implementation choices
- **Existing codebase patterns** — naming conventions, layering, established idioms
- **Other milestone plans** — cross-milestone consistency (shared types, naming, contracts)

### Review Criteria

1. **Architectural alignment**: Does the plan match the layering, packaging, and
   responsibility boundaries established in design docs?
2. **Naming consistency**: Do types, methods, enums, and concepts use the same names
   as design docs and ADRs? Flag any divergence.
3. **Content density**: Are code examples at the right level — intent-conveying, not
   implementation-dictating? Apply Rule 1 and reduce over-specified blocks.
4. **ADR compliance**: Does the plan respect recorded decisions? If it deviates, is
   the deviation intentional and documented?
5. **Cross-milestone coherence**: Are shared types, API contracts, and naming consistent
   across milestone plans that touch the same domain?

### Review Output

- Add a **Review Notes** section at the end of the plan documenting:
  - Issues found and how they were resolved
  - Decisions made during review (with rationale)
  - Any intentional deviations from design docs (with justification)
- Fix issues directly in the plan — do not leave known problems for the implementer.
- If an issue cannot be resolved without user input, flag it and pause.

### When to Review

- After the plan is written and before implementation begins.
- After significant changes to a plan that has already been reviewed.
- When design documents or ADRs are updated in ways that may affect existing plans.

# Technical Decisions

## Trade-offs Documentation
- Capture trade-offs in commits and code comments: why simple solutions were chosen, when technical debt is acceptable, and future migration paths.
- Explain choices such as in-memory vs distributed approaches and why they fit current needs.

## Decision Records
- When a task introduces or confirms a meaningful technical decision, check whether the repository has a decision-record system such as ADRs.
- If such a system exists, record new or newly clarified decisions there rather than leaving the rationale only in chat or commit history.
- Typical candidates include architecture direction, persistence policy, API semantics, data lifecycle, testing strategy, and environment strategy.
- Do not create decision records for trivial implementation details.

## Research Decision Workflow

When a task begins as explicit research or investigation and ends with a technical choice,
that choice must be treated as a formal decision workflow rather than an implicit agent choice.

Required sequence:

1. investigate the options
2. summarize the options with balanced pros/cons for the human
3. pause for the human decision, or for a request for deeper research
4. once the human chooses, record the outcome in the repository's decision-record system
5. update the affected implementation plan, roadmap, or agent plan to reflect the decision
6. only then proceed with implementation

Additional rules:

- Research that concludes with an architectural, dependency, UX-pattern, testing, or
  implementation-shape choice must produce an ADR when the repository uses ADRs.
- The ADR should capture the options considered, the decision, and the main trade-offs.
- The affected plan artifact must be updated in the same workflow so implementation starts
  from recorded decisions rather than chat-only conclusions.
- If the human has not made the decision yet, do not write the ADR as accepted and do not
  proceed as though the outcome were settled.

## Documentation Coverage
- Before proposing a commit, ask whether the change altered:
  - a meaningful technical decision,
  - local developer setup or bootstrap steps,
  - how the system is run, tested, or validated.
- If yes, ensure the repository documentation reflects it.
- If the repository uses ADRs, put decision rationale there. If it uses READMEs or runbooks for setup and workflow, update those too.

## Example Trade-offs (patterns to consider)
- In-memory state can be acceptable at small scale when restart loss is tolerable; move to shared/distributed storage as coordination needs grow.
- Avoid cross-instance coordination until scale requires it; design a path to migrate if/when needed.
- Use configuration to tune limits per environment (e.g., lower limits in tests, higher in production).

## ADR Re-read Loop

Meaningful implementation work must review relevant decision records twice:

### 1. Before Implementation

- Re-read the decision records (e.g., ADRs) that constrain the change area before
  coding.
- Treat this as part of analysis/design, not optional background reading.
- Typical examples: testing strategy, API semantics, seeding, auth/session rules,
  frontend state patterns.

### 2. After Implementation

- Re-check the same decision records against the actual diff before calling the
  work done.
- Confirm the implementation still matches the intent of the decision, not just
  the originally planned design.
- If the implementation clarified or changed a meaningful decision, update the
  decision record before proposing a commit.

### 3. Review Triggers

This double-check is especially required when:

- introducing new infrastructure abstractions
- adding or renaming API endpoints
- changing test strategy or test setup patterns
- touching onboarding, auth, session, or seeding behavior
- adding builders, fixtures, or non-deterministic dependency handling

Skipping this review loop is a process bug. If the relevant decision-record set
is unclear, stop and identify it before continuing.

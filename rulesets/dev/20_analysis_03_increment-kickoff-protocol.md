# Increment Kickoff Protocol

When starting a new release, feature set, or significant increment of work, run this
four-phase kickoff protocol **before any implementation begins**. Each phase has an
explicit human confirmation gate.

This protocol is additive — the existing implementation, quality, and
change-persistence workflow
phases run unchanged after the kickoff is complete.

---

## When to Run

Run the **full protocol** when:

- Starting a new release or version.
- Starting a set of increments that introduces new API contracts, data models, or
  cross-stack behavior.
- The user explicitly asks for a planning or scoping phase.

You may **start at Phase 2** if the scope is already explicitly defined in the session.

You may **start at Phase 3** if the architecture has already been agreed and is
documented from a prior session.

You may **start at Phase 4** if the increment breakdown already exists and you are
resuming work on a known, planned increment.

**Never skip Phase 4** — always produce an Agent Plan before starting a new
increment or commit boundary.

---

## Phase 0: Codebase and Documentation Preparation

Before producing any scope brief, architecture proposal, or plan, complete the
preparation steps defined in `20_analysis_02_implementation-plan-standards.md` Rule 0:

1. **Read design documentation** — all technical design docs and ADRs relevant to the
   area being planned, including any that cover error handling, type safety, or test
   architecture even when the feature does not obviously touch those areas.

2. **Explore the relevant code area** — read adjacent files, sibling classes, and
   analogous services in full. Read the tests for those analogous classes.

3. **Summarize observed patterns** — produce an internal summary of how the codebase
   handles errors, models absence, enforces type boundaries, and structures its layers.
   This summary is the baseline every subsequent planning decision must be consistent with.

This phase has no user-facing output unless the user asks. It is not skippable.
The Feature Scope Brief in Phase 1 is only as accurate as the preparation behind it.

---

## Phase 1: Feature Scope Brief

Produce a **Feature Scope Brief** — a concise, product-level description of what the
increment or release delivers.

The brief answers:

- What user capability or system improvement does this deliver?
- What is explicitly in scope and what is out of scope?
- What are the success criteria — how do we know it is done?
- What are the known unknowns, risks, or dependencies?

### Output format

| Increment size | Output |
|---|---|
| Single increment (one PR, contained scope) | In-chat summary |
| Multiple increments or cross-cutting scope | File in `docs/planning/` |

**Hard stop**: Present the Feature Scope Brief and wait for explicit user confirmation
before proceeding to the architecture phase.

---

## Phase 2: Architecture Proposal

After scope is confirmed, produce an **Architecture Proposal** — a technical design
document covering the high-level structure before any code is written.

The proposal covers:

- **API contracts**: Key request/response payload shapes for new or changed endpoints.
- **Data model changes**: Schema additions, new entities, field-level intent.
- **Component and service structure**: Where the logic lives; new services, hooks,
  or components needed and their responsibilities.
- **Data flow**: For non-trivial flows, a sequence or data-flow description.
- **Key decisions and trade-offs**: What alternatives were considered and why this
  approach was chosen.

The proposal stays **high level** — field names and method signatures, not
implementation bodies. See `20_analysis_02_implementation-plan-standards.md` for
content density guidance.

### Output format

| Change scope | Output |
|---|---|
| No schema or API changes (UI, refactor, tooling) | In-chat proposal |
| Schema changes or API contract changes | File in `docs/planning/` |

**Hard stop**: Present the Architecture Proposal and wait for explicit user
confirmation that the architecture is aligned. Do not proceed to increment planning
until the user explicitly signs off on the design. This is a mandatory gate.

---

## Phase 3: Increment and Slice Breakdown

After architecture is confirmed, produce the **Increment Breakdown** — a structured
plan of what gets built, in what order, and at what PR boundaries.

Each increment entry includes:

- What it delivers (user or system outcome).
- Which tasks or slices it contains.
- Estimated churn and PR boundary rationale (see the repository's
  `local/21_implementation_17_release-increment-task-planning.md`).
- Dependencies on other increments, if any.

This step translates the architectural alignment into the plannable work queue using
the canonical Release → Increment → Task hierarchy.

**Output**: Written to the relevant `docs/planning/` document (new file, or appended
to an existing version plan).

---

## Phase 4: Agent Plan (Per Increment)

Before starting work on any increment or commit boundary, produce an **Agent Plan** —
a concrete, step-by-step execution plan scoped to that increment only.

The Agent Plan:

- References the confirmed architecture — no redesign at this phase.
- Lists each task in implementation order.
- Identifies the test strategy per task.
- Notes any ADRs to re-read before starting (see `20_analysis_01_technical-decisions.md`
  for the ADR double-check rule).
- Follows the content density and cross-review standards in
  `20_analysis_02_implementation-plan-standards.md`.

**Output**: Written to `docs/planning/` as a standard implementation plan document.

**Hard stop before implementation**: Present the Agent Plan and wait for user
acknowledgment before writing any production code.

---

## Summary Sequence

```
Codebase & Documentation Preparation  (Phase 0 — internal, no user gate)
        ↓
Feature Scope Brief  →  [user confirms scope]
        ↓
Architecture Proposal  →  [user confirms architecture]
        ↓
Increment & Slice Breakdown  →  [user reviews breakdown]
        ↓
Agent Plan (per increment)  →  [user acknowledges]
        ↓
Implementation  →  Quality gates  →  Change persistence  →  PR

```

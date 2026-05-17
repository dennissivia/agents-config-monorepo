# Compiled AI Instructions

This file is generated from the `agents-config` monorepo.

Source of truth:
- `00_index.md`
- `rulesets/`

Included rule sets:
- `installed-agents`

---

## examples/dev-minimal/.agents/00_index.md

# AI Instruction Dispatcher

This repository can be used directly as a `.agents/` folder when cloned into a host repository.

Production rule sets live under `rulesets/`.

Default active rule sets for direct clone mode:
- `rulesets/global/`
- `rulesets/dev/`

Load order:
1. Load this `00_index.md` first.
2. Load `rulesets/00_index.md`.
3. Load the selected rule-set files in numeric order.
4. Load `.agents.local/00_index.md` in the host repository, if present.
5. Load project-local overrides from `.agents.local/` only when explicitly referenced.

Rule-set ranges:
- `01-09`: global rules.
- `10-19`: workflow indexes and setup.
- `20-69`: workflow stage rules.
- `70-79`: experimental rules, loaded only when explicitly requested.
- `80-99`: reserved.

Inactive support folders:
- `docs/`
- `bin/`
- `dist/`

These folders are not active instruction sources unless an active instruction file explicitly references them.

Project-specific overrides belong in `.agents.local/`, not in this shared repository.

## examples/dev-minimal/.agents/dev/10_dev-workflow.md

# Development Workflow

This file is the entrypoint for development work. If a separate global package is present (`01–09`), load that first, then apply this workflow and the stage files in numeric order (`20–69`). This workflow ensures clarity, predictability, and safe collaboration. All tasks follow these phases unless explicitly overridden.

---

## Phase 0: Initialization
- Re-read the `.agents/` rules.
- Confirm understanding of the task, constraints, and context.
- Ask clarifying questions when information is incomplete.

---

## Phase 1: Planning
- Identify the goal, scope, risks, dependencies, and assumptions.
- Outline the steps required to deliver the task.
- Surface uncertainties early.

---

## Phase 2: Analysis
- Inspect relevant code, architecture, files, and constraints.
- Document important findings before designing anything.
- Highlight inconsistencies or risks in existing code.

---

## Phase 3: Design
- Propose architecture, components, function signatures, data structures, or flows.
- Offer 1–2 viable alternatives when appropriate.
- Confirm the design with the user before coding.

---

## Phase 4: Implementation
- Produce incremental code that is readable and reviewable.
- Prefer small steps over monolithic output.
- Keep to the confirmed design.

---

## Phase 5: Refinement & Refactoring
- Review code for clarity, correctness, and maintainability.
- Apply safe refactorings only.
- Document important reasoning when refactoring.

---

## Phase 6: Quality Measures
- Run formatting, linters, tests.
- Code must pass all mandatory checks before any git action.

---

## Phase 7: Git Operations (Confirmation Required)
- Ask for confirmation before any git push, commit, rebase, merge, or PR creation.
- Follow the repository’s branch and PR conventions.

---

This workflow creates a predictable, token-efficient, verifiable development process for both humans and AI agents. If additional package indexes are added (e.g., QA or writing packages), load them after this file and follow their numeric ranges.


## examples/dev-minimal/.agents/global/01_purpose-and-scope.md

# Purpose and Scope (Global)

The `.agents/` folder defines the **AI collaboration rules**: a minimal, high-signal set of guidance that ensures safe, predictable, high-quality work between humans and AI assistants. It replaces prior custom naming (e.g., “AI Development Contract”) and is the single source of truth.

These global rules establish:
- **How AI should behave** in planning, design, coding, analysis, and refactoring.
- **How work is structured** through a shared, multi-phase workflow.
- **How quality, security, and git hygiene** are enforced consistently.
- **How context is maintained**, updated, and compiled across projects.
- **How local and global rules interact**, including project-specific overrides.

Global (`01–09`) rules apply before any package- or workflow-specific guidance.

This ruleset is optimized for:
- AI agents working in multi-step pipelines.
- Teams needing consistent behavior across repositories.
- Scenarios where token budget is limited and clarity matters.

Stack-specific examples may appear in workflow files but are always **adapted**, never ignored.



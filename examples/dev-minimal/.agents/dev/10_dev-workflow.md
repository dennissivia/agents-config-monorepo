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

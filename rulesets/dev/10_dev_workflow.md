# Development Workflow

This file is the entrypoint for development work. If a separate global package is present (`01–09`), load that first, then apply this workflow and the stage files in numeric order (`20–69`). This workflow ensures clarity, predictability, and safe collaboration. All tasks follow these phases unless explicitly overridden.

---

## Workflow Summary

Legend:
- `[AUTO]` = automatic transition to the next phase.
- `[HANDOFF]` = user confirmation required before proceeding.

```
Phase 0  Rule Bootstrap
	[AUTO]
		↓
Phase 1  Scope Intake And Documentation Load
	[HANDOFF]
		↓
Phase 2  Scope Validation And High-Level Plan
	[HANDOFF]
		↓
Phase 3  Analysis And Design Synthesis
	[AUTO]
		↓
Phase 4  Agent Plan And Implementation Readiness
	[HANDOFF]
		↓
Phase 5  Implementation
	[AUTO]
		↓
Phase 6  Refinement And Refactoring
	[AUTO]
		↓
Phase 7  Quality Assurance
	[AUTO]
		↓
Phase 8  Change Persistence (Commit/Push)
	[HANDOFF]
		↓
Phase 9  Code Review (Pull Request + Review Iteration)
	[AUTO on merge/close detection]
		↓
Phase 10 Integration And Deployment
```

---

## Phase 0: Rule Bootstrap

Purpose:
- Load the right agent-rule set before any scope interpretation begins.

Inputs:
- Active task request.
- `.agents/` rule index and phase rules.

Core actions:
- Re-read `.agents/` rules with priority on planning, analysis, design, quality
	assurance, and change-persistence rules.
- Determine which workflow package and prefix range apply to this task.

Outputs:
- Confirmed rule baseline for the active task.

Transition to Phase 1:
- `[AUTO]`

---

## Phase 1: Scope Intake And Documentation Load

Purpose:
- Gather all scope-defining artifacts before planning decisions.

Inputs:
- User request and current task state.
- Existing roadmap/version/increment/plan files.
- Product notes, ADRs, and technical documentation relevant to scope.

Core actions:
- Locate the active scope source (roadmap, versioned plan, increment plan, or
	explicit user direction).
- Determine whether work is a continuation of an existing increment or a new slice.
- Read essential documentation:
	- ADRs that constrain the work.
	- Technical docs for the touched domain.
	- Product vision/notes that define intent.
- For new release or major increment work, route through
	`20_analysis_03_increment-kickoff-protocol.md`.
- Apply the fixed rule: documented repository decisions override community defaults
	and generic model priors.

Outputs:
- Consolidated scope context.
- Document set that constrains the next planning step.

Transition to Phase 2:
- `[HANDOFF]` present scope intake summary and confirm the interpreted scope.

When starting a new release or significant increment, run the **Increment Kickoff
Protocol** (`20_analysis_03_increment-kickoff-protocol.md`) before this phase. The
kickoff phases (Feature Scope Brief → Architecture Proposal → Increment Breakdown →
Agent Plan) complete before the implementation workflow continues.

For work already inside a planned increment, proceed from the Agent Plan directly into
implementation.

---

## Phase 2: Scope Validation And High-Level Plan

Purpose:
- Validate scope quality and produce an execution direction at management level.

Inputs:
- Scope intake output from Phase 1.
- Existing agent plan (if available).

Core actions:
- Validate the scope for contradictions, missing boundaries, and feasibility.
- Identify risks, dependencies, assumptions, and uncertainty categories:
	- open questions
	- contradictions
	- dependency gaps
	- risk concentration
	- scope creep or unclear goals
- Check for an existing agent plan:
	- if present: cross-reference plan sections against the validated scope
	- if absent: propose creating a new plan artifact
- Ask focused clarification questions until critical uncertainties are resolved.
- Present a high-level delivery plan (outcome-level, minimal implementation detail).

Outputs:
- Resolved uncertainty list or explicit unresolved blockers.
- Confirmed high-level plan direction.

Transition to Phase 3:
- `[HANDOFF]` user confirms high-level plan direction and plan creation/update path.

---

## Phase 3: Analysis And Design Synthesis

Purpose:
- Ground the planned direction in repository-specific implementation reality.

Inputs:
- Confirmed high-level plan from Phase 2.
- Relevant code areas and existing tests.

Core actions:
- Inspect implementation patterns in the target modules.
- Identify inconsistencies, technical risks, and dependency constraints.
- Reconfirm precedence rules:
	- user instruction
	- ADRs/technical docs
	- established local code patterns
	- community/reference patterns
- Produce a concise design synthesis:
	- components and boundaries to extend or introduce
	- relevant APIs/contracts to touch
	- minimal architectural shape needed for implementation

Outputs:
- Design synthesis aligned with repository conventions.
- List of inconsistencies requiring clarification in next phase.

Transition to Phase 4:
- `[AUTO]`

---

## Phase 4: Agent Plan And Implementation Readiness

Purpose:
- Convert synthesis into an executable agent plan and prepare implementation entry.

Inputs:
- Phase 3 synthesis and inconsistency list.
- Repository planning conventions and target plan location.

Core actions:
- Resolve remaining inconsistencies in files, signatures, or architecture assumptions.
- Present short design proposal (maximum two paragraphs plus concise bullets).
- Create or update the agent plan artifact in the repository-defined planning location.
- Ensure the plan documents:
	- key classes/components/contracts
	- implementation sequence
	- test/QA intent
	- enough structure for another coding agent to execute reliably
- Prepare implementation entry conditions:
	- check branch/worktree safety and cleanliness expectations
	- apply branch-creation and checkout rules from the persistence workflow files

Outputs:
- Approved agent plan artifact.
- Implementation-ready workspace and branch strategy.

Transition to Phase 5:
- `[HANDOFF]` user confirms plan and implementation start.

---

## Phase 5: Implementation

Purpose:
- Deliver the approved plan increment in production code and tests.

Inputs:
- Approved agent plan and implementation-ready branch/workspace.

Core actions:
- Produce incremental code that is readable and reviewable.
- Prefer small steps over monolithic output.
- Keep to the confirmed design.

Outputs:
- Implemented change slice with aligned tests/docs as required.

Transition to Phase 6:
- `[AUTO]`

---

## Phase 6: Refinement & Refactoring

Purpose:
- Reduce complexity and improve maintainability without changing behavior.

Inputs:
- Implemented slice from Phase 5.

Core actions:
- Review code for clarity, correctness, and maintainability.
- Apply safe refactorings only.
- Document important reasoning when refactoring.
- Perform mandatory self-review and size/diff review per QA rules.

Outputs:
- Refined implementation ready for full QA.

Transition to Phase 7:
- `[AUTO]`

---

## Phase 7: Quality Assurance

Purpose:
- Run the full QA process that proves the refined change is safe to persist.

Inputs:
- Refined implementation from Phase 6.

Core actions:
- Run all defined quality gates for the changed scope.
- Include formatting, linting, tests, coverage, self-review, size review, and
	other repository-defined QA dimensions where applicable.
- Code must pass all mandatory checks before persistence actions.

Outputs:
- Quality-assurance results with quality-gate and review outcomes.

Transition to Phase 8:
- `[AUTO]`

---

## Phase 8: Change Persistence (Confirmation Required)

Purpose:
- Persist approved work through commit and branch-push workflow with explicit approvals.

Inputs:
- Quality-assurance results from Phase 7.
- Current branch/worktree state and working-tree diff.

Core actions:
- Verify the work is on the expected feature branch or requested worktree
	before any commit action.
- Inspect changed files and identify the files related to the current work,
	including docs and agent rules when they are part of the slice.
- Exclude unrelated local changes from staging and persistence.
- Re-read the applicable persistence, commit-template, and commit-content rules.
- Present the proposed staging scope, commit strategy, and rendered commit
	message.
- Hard handoff for explicit persistence approval before staging, committing,
	pushing, or starting review publication.
- After approval, execute commit preparation, commit writing, and optional
	branch push per repository rules.
- Follow branch, commit, and branch-publication conventions.

Outputs:
- Persisted local and/or pushed branch state ready for continued work or review publication.

Transition to Phase 9:
- `[HANDOFF]` user confirms review publication when the slice is ready for code review.

---

## Phase 9: Code Review

Purpose:
- Publish the change for review and iterate on review feedback until the review
	loop is complete or the branch is merged/closed.

Inputs:
- Persisted changeset from Phase 8.
- Branch push state and user approval to start review publication.

Core actions:
- Create and maintain the pull request / review artifact according to repository
	review rules.
- Ensure review title/body content stays aligned with the current branch state.
- On the last increment of a versioned release, confirm the codebase already
	contains the intended version bump before review publication.
- Re-read and triage review feedback when new comments appear.
- Present review-fix plans to the user, implement approved fixes, commit them,
	push them, and continue the review loop while there are new comments.
- Stay in this phase until review work is exhausted for now or merge/close is detected.

Outputs:
- Active review artifact aligned with the latest branch state, or a merged/closed
	review outcome ready for post-merge integration.

Transition to Phase 10:
- `[AUTO]` when merge/close is detected.
- Otherwise remain in Phase 9 until the review loop advances.

---

## Phase 10: Integration And Deployment

Purpose:
- Synchronize the local workspace after merge and perform any required manual or
	locally triggered deployment steps.

Inputs:
- Merged or closed review outcome.
- Local workspace state and repository deployment conventions.

Core actions:
- Sync the local checkout back to the integration branch according to repository rules.
- Clean up feature-branch state, including safe stash / restore handling when needed.
- Determine whether deployment action is needed:
	- automated deployment already handled it
	- local/manual deployment is required
	- no deployment is needed because the merged slice was docs-only or non-runtime
- Before any local/manual deployment, ask the user for confirmation.
- If local/manual deployment is required and code changes are currently in the
	working tree, stash them before deployment and restore them afterward.

Outputs:
- Synced local workspace and deployment state accounted for.

---

This workflow creates a predictable, token-efficient, verifiable development process for both humans and AI agents. If additional package indexes are added (e.g., QA or writing packages), load them after this file and follow their numeric ranges.

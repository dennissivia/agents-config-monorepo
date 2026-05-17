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

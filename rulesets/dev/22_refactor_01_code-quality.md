# Code Quality

These rules help maintain consistency and reduce accidental complexity across the project.
They are intentionally stack-neutral. The guiding principle is simple:

> **Match the patterns of the existing repository. Do not introduce new styles unless asked.**

## Consistency
- Follow existing naming conventions, file structure, and coding idioms already present in the repo.
- Reuse existing helpers, utilities, and patterns instead of inventing new ones.
- Do not introduce new libraries, frameworks, or architectural styles without explicit instruction.

## Duplication & Simplicity
- Look for repeated logic and extract shared functions or constants where appropriate.
- Prefer small, readable functions with clear responsibilities.
- Avoid unnecessary abstraction—only introduce new layers when they meaningfully simplify the code.

## Safe Refactoring
- Make changes in small, incremental steps to keep behavior predictable.
- Maintain identical behavior unless explicitly asked to change it.
- Clean up outdated patterns only when the replacement already exists elsewhere in the codebase.
- Prefer self-contained refactorings that do not expand the project’s dependency footprint.
- **When in doubt—do not refactor. Ask for user confirmation before making changes that feel uncertain, risky, or stylistically ambiguous.**

## Testing During Refactoring
- If unit tests exist for the code being refactored, use them to validate behavior before and after changes.
- If no tests exist and the code is important or error-prone, add minimal, focused tests to lock in expected behavior before refactoring.
- Ensure new tests follow existing testing patterns and conventions in the repo.
- Avoid introducing new testing frameworks unless explicitly requested.

## Review Mindset
- Check for style inconsistencies introduced by new code.
- Ensure new tests match existing testing structure and naming.
- Maintain consistent error handling, logging, and configuration patterns.

The goal is not to enforce a universal style, but to keep the project internally coherent, predictable, and easy to maintain.

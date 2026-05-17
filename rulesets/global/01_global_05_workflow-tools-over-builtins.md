# Defined Workflow Tools Take Precedence Over Built-ins

When a `.agents/` rule (shared or local) names a specific tool, script, or command for a use
case, that tool **must** be used instead of any built-in or generic alternative. Built-in
tools are not the default for use cases the workflow already covers.

Workflow tools are picked on purpose: they enforce authentication, preserve security
boundaries, apply repository conventions, and produce output the rest of the workflow
depends on. Reaching for a generic built-in silently bypasses those guarantees.

For example, fetching PR review feedback uses the repo's helper script (per
`26_pr_02_reading-pr-review-comments.md`), not hand-written `gh api` calls. The same
principle applies in every phase — planning, implementation, validation, git, PR review.

If a defined tool genuinely cannot serve the need, stop and report the gap to the user
instead of silently falling back to a built-in.

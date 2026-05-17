# Reading Review Comments

This file defines the shared workflow expectation for loading review feedback
from an active pull request.

Repository-local rules may define the exact helper script or API command to use.
Those local rules take precedence.

---

## Purpose

When review feedback exists, the agent must gather the full review set before
triaging or fixing anything.

That includes:

- top-level review summaries
- inline review comments
- enough metadata to identify each comment during triage and follow-up

---

## Shared Rule

When the agent is asked to assess or address review feedback:

1. load the current review summaries,
2. load the current inline comments,
3. capture the comment identifiers needed for later reply or resolution,
4. use that complete set as the basis for triage.

Do not triage from memory, from partial excerpts, or from a single quoted
comment when the full review set is available.

---

## Separation Of Responsibilities

Keep these review activities distinct:

- **feedback loading**: gather the current review state
- **triage**: assess priority, applicability, and proposed fixes
- **fix cycle**: implement approved changes
- **follow-up**: reply, resolve, and continue the review loop

---

## Safety Rule

Do not start implementing review fixes before the full current review set has
been loaded and presented to the user in triage form.

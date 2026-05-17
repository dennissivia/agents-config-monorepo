# Commit Messages

Commit messages are a core part of the development workflow.
They are written **for humans**, not machines.
A good commit message provides clarity, intent, reasoning, and readability.

Use the structured template for all substantive feature work, fixes, and improvements.
Use the follow-up template for PR review fixes, bug fixes, and small corrections.
Keep documentation-only updates simple and focused.

---

## Before Writing: Understand the Full Scope

**Before drafting a commit message:**

1. **Understand what was accomplished.** What is the key achievement or change?
2. **When in doubt, ask the user** what the primary goal or message should be.
3. **Never just list what changed**—the diff already shows that.
4. **Focus on WHY and HOW**, not WHAT:
   - WHY: What problem did this solve? What gap did it fill?
   - HOW: What approach, decisions, or trade-offs were involved?
   - WHAT: Avoid restating file changes, line edits, or implementation details visible in the diff.

The commit message should tell the story behind the change, not narrate the change itself.

---

## Drafting Workflow

**Always propose the commit message as rendered Markdown in the chat first.**

- Draft the message and show it to the user for review.
- Only construct shell commands (`mktemp`, `cat`, `git commit -F`) after the user approves the content.
- This avoids constant rejection of shell commands and makes the message easy to read and discuss.

---

## Writing Stance and Language (Mandatory)

Every commit message and PR body **must** be written from the perspective of a
**technical project manager or senior engineering manager addressing product
and business stakeholders**, not from the implementing engineer's
perspective. This is a hard requirement and applies to every commit and PR
in every repository.

ADRs, agent plans, implementation plans, and other internal engineering
artifacts may use more technical language, but commits and PRs always use
this business-facing stance.

### Required stance

- Summarize **capabilities, goals, and intents** — what the product or
  codebase now has, and why it matters.
- Use **plain, professional English**: short sentences, clear nouns, common
  verbs.
- Describe **value**, not the mechanism that delivers it.
- Stay at the abstraction level a senior manager uses when briefing product
  or business — concrete enough to be honest, abstracted enough to be
  portable across audiences.

### Forbidden language

The following must not appear in commit messages or PR bodies:

- **AI or agent vernacular**: "lifts X out of", "wires up", "stitches in",
  "spins up", "lands", "ships", "in flight", "stable anchor", "scaffolding
  for", "happy path baked in".
- **Developer or internet slang**: "DX", "QoL", "shiny", "battle-tested",
  "first-class", "low-hanging fruit", "drop in", "swap out", "plumbing".
- **Internal labels without explanation**: "I9", "M3", "Sprint 4", version
  codenames, bare ticket IDs. Replace each with the product or engineering
  outcome behind the label.
- **Process meta-commentary about the commit boundary**: "this commit", "as
  its own change", "in a later PR", "in the next commit". Speak about the
  product and the codebase, not about how the work was sliced.
- **Colloquial verbs that hide the change**: "consistency pass", "cleanup
  sweep", "polish", "tidy".

### Allowed technical vocabulary

Technical terms are allowed when they name a real product or engineering
capability a senior manager would discuss with product owners (for example
"rate limiting", "session fixation prevention", "soft delete",
"accessibility scan", "internationalization coverage"). File names, route
paths, class and method names, HTTP headers, and database columns remain
forbidden regardless of audience.

### Fallback

If a change cannot be described without forbidden language, the description
is not ready. Re-read the diff and the goal, then rewrite at the
product-and-business level. Do not commit until the description holds at
that level.

---

## Critical Rules

1. **Always start with a fitting emoji.**
   It visually conveys the type of change and increases scan-ability.
   Choose the emoji by semantic fit. Do not default to the same emoji when a
   more accurate one exists for the actual change.

2. **Write for human readers**—reviewers today and future contributors tomorrow.
   The message must be easy to understand without reading the diff or knowing the conversation.

3. **Explain the goal, the why, and the reasoning.**
   The diff shows the *what*. The commit message explains the *motivation* and *decisions*.

4. **Stay structured and concise.**
   Follow the template exactly. No extra sections; no noise or verbose play-by-play.

5. **Lead with user value.**
   When technical changes accompany a feature, keep the user-facing purpose at the top.

6. **Use short paragraphs and readable sentences.**
   The message must be digestible in ~30 seconds.

7. **Never include:**
   - debug notes
   - exploration steps
   - implementation details evident from the diff
   - internal monologue
   - overly technical or low-signal text
   - unexplained internal increment IDs, roadmap IDs, ticket labels, or version shorthand unless the user explicitly wants them in the message
   - colloquial labels such as "consistency pass", "cleanup sweep", or similar shorthand that hides the actual reason for the change
   - contrastive or negative framing such as "this is X, not Y" or lists of things the change does not do
   - self-justifying language that defends scope instead of explaining the context that led to the work

---

## Subject Prefix Format

Commit subjects use a capitalized, long-form intent prefix followed by a colon.
The prefix makes the change type scannable without adopting Conventional Commits.

Required subject shape:

```markdown
<emoji> <Prefix>: <imperative subject>
```

Use these prefixes:

- `Feature:` for user-facing functionality and behavior changes
- `Bugfix:` for bug fixes and production regressions
- `Tech:` for internal engineering work, refactors, infrastructure, or quality work
- `Docs:` for documentation, ADR, roadmap, README, or rule-only changes

Examples:

```markdown
🔐 Feature: Add passkey sign-in to auth page
🐛 Bugfix: Fix mobile overview layout regressions
🛠️ Tech: Clean up test data builders
📝 Docs: Document repository title prefix convention
```

Rules:

- Use the colon form in commit titles, never slash prefixes such as `feature/` or `bugfix/`.
- Use long-form prefixes; do not use abbreviations such as `Feat:`, `Fix:`, or `fix:`.
- Keep the subject after the prefix imperative / present tense.
- Branch names are different: they use lowercase slash prefixes such as `feature/...`
  and `bugfix/...`.

---

## Length Target

**The entire message (title through last section) should be under 30 lines.**
If it exceeds that, you are probably narrating the diff instead of summarizing decisions.
Less is more — as long as all key ideas are captured, shorter is better.

---

## Narrative Requirements (Critical)

A high-quality commit message body **must**:

- Describe the **goal** of the change. What is the purpose?
- Explain **why** the change was needed. What problem or gap existed?
- Summarize the key **trade-offs**, considerations, and decisions involved.
- Provide context so a reviewer or future contributor understands intent quickly.
- Be **reader-friendly**: short paragraphs, clear reasoning, no jargon unless necessary.
- Stand on its own—someone reading the commit without the PR or conversation should understand the intent.

The `Context / intent` section must explain the prior condition, inconsistency, or pressure that led to the change. It must not read like a defense of scope, a rejection list, or a note about what the implementation deliberately avoided.

Low-quality, non-narrative commit messages must never be produced.

---

## Commit Subject Tense

Use **imperative / present-tense** commit subjects.

Good:

- `add passkey sign-in to auth page`
- `fix passkey cancellation handling`
- `document repository commit prefixes`

Bad:

- `added passkey sign-in to auth page`
- `fixed passkey cancellation handling`
- `documented repository commit prefixes`

The subject should read like an instruction to the codebase:

- `add`, not `added`
- `fix`, not `fixed`
- `document`, not `documented`

This guidance is compatible with many common Git recommendations and should be
followed unless a project defines a stricter local convention.

---

## Emoji Fit

The emoji should match the change category rather than being chosen by habit.

Examples:

- `🔐` auth, security, passkeys
- `✨` new feature or new capability
- `🛠️` technical/internal improvement
- `📝` docs, ADR, README, rules
- `🐛` bug fix
- `♻️` refactor
- `✅` test-focused or validation-focused work

The goal is not novelty. The goal is to avoid repetitive, low-signal emoji use
when a more accurate symbol exists.

---

## Template

```markdown
<emoji> <Prefix>: <short imperative description>

## Summary
<One sentence: human-level outcome (what changed for a user/system)>

## Context / intent
<1–3 sentences: why this was needed / why now; key constraint; key trade-off if relevant>

## Key changes
- <1–5 bullets max: high-impact deliverables grouped by theme or user feature>
- <Less is more — capture key ideas, skip everything else>

## Additional changes (optional)
<Out-of-scope changes that are not a subset of key changes but add value>
- <1–3 bullets max>

## Validation / quality
- **Test focus:** <High-level use cases or behavior areas the tests focused on; no file names or test counts>
- **Automated tests:** <Pass/fail outcome and new/updated unit, integration, or E2E coverage areas>
- **Manual tests** (optional): <Manual QA explicitly performed or requested by the human>
- **Findings** (optional): <Bugs found during QA that were fixed immediately or added to the backlog>

## Future improvements (optional)
<Only if the user explicitly called out a deferral or accepted limitation>
- <1–2 bullets max; omit section if none>

## References (optional)
<Only if the user explicitly linked an issue or external doc; omit if none>
```

---

## When to Use Which Template

The **full template** (above) is for **primary feature commits and PR bodies** — work that
introduces new functionality, establishes new patterns, or makes substantial architectural
changes. These are the commits that become the permanent record on `main` (especially with
squash merge).

The **follow-up template** (below) is for everything else:
- Addressing PR review comments
- Bug fixes
- Small misses or corrections
- Refactoring follow-ups
- Any commit that is a response to feedback rather than original work

When a PR has a single commit, `gh pr create --fill` uses the full template as the PR body.
Follow-up commits within the same PR use the follow-up template.

---

## Follow-Up / Fix Commit Template

```markdown
<emoji> <Prefix>: <short imperative description>

## Summary
<One sentence: what was addressed>

## Key changes
- <What was fixed and how — focused on the actual issues addressed>
- <Each bullet = one fix or closely related group of fixes>
- <Small incidental changes (config cleanup, dev artifact removal) do not need listing>

## Validation / quality
- **Test focus:** <High-level use cases or behavior areas the tests focused on; no file names or test counts>
- **Automated tests:** <Pass/fail outcome and new/updated unit, integration, or E2E coverage areas>
- **Manual tests** (optional): <Manual QA explicitly performed or requested by the human>
- **Findings** (optional): <Bugs found during QA that were fixed immediately or added to the backlog>
```

### Follow-Up Template Rules

1. **No Context / Intent section.** The parent commit or PR body provides the context.
   The follow-up exists to address feedback — the "why" is self-evident.

2. **No Additional Changes section.** If small incidental things come along (a gitignore
   tweak, removing a stale file, config cleanup), they just go with it. They don't need
   to be accounted for in the message. Only list them if a reviewer would genuinely ask
   "why is this here?"

3. **Key changes = what was addressed.** Each bullet describes a fix or improvement that
   directly responds to feedback. Meta-artifacts (ADRs, agent rules) created as part of the
   fix process are not key changes — they support the fix but are not the fix itself.

4. **Validation focuses on quality delta.** State the use cases covered and
   whether automated tests passed. Mention manual QA or findings only when
   they add real information.

5. **Length target: under 20 lines.** Follow-ups should be quick reads.

---

## Section Guidance

### Summary — The Product Manager Test

State the outcome in a way a **product manager** would understand.
If your summary requires knowledge of specific classes, frameworks, or file paths, rewrite it.

Ask yourself: "Would a non-engineer understand what this delivers and why it matters?"
If no, rewrite it.

### Context / intent — Explain Why, Not What Was Excluded

The `Context / intent` section explains why this work happened now and what condition made it necessary.

Good context usually includes one or more of:

- the inconsistency, bug, risk, or workflow problem that existed before the change
- the product or engineering pressure that made the change worth doing now
- the decision path or constraint that shaped the chosen implementation

Do not write this section as a contrast against alternatives or exclusions.

**Good:**
> Before this change, similar forms validated input in different ways, which made trimming, whitespace rejection, and optional-field normalization inconsistent across the UI.

**Good:**
> We already had shared validation helpers, but several submit paths still used ad hoc guards. Aligning those paths now reduces user-facing inconsistency and makes later validation work easier to evolve.

**Bad:**
> This is a consistency pass, not a redesign.

**Bad:**
> This change does X and does not do Y.

**Bad:**
> We intentionally did not adopt a bigger architectural change here.

### Key Changes — Features and User Outcomes, Not Code

Key changes describe **what users or the product can now do** — not what files changed or
how the code works. Write as if explaining to a product owner, not a code reviewer.

**Default: product language.** Technical language is only acceptable when:
- The change is infrastructure with no user-facing equivalent (e.g., "Rate limiting on sign-in to prevent abuse")
- The change is security-critical and the nature of the protection is the point (e.g., "Session fixation prevention on sign-in")
- The audience is explicitly engineers (e.g., a pure refactor or migration)

**Never acceptable in key changes:**
- API route paths (`/api/auth/start`)
- Class or method names (`AuthController`, `findByEmail()`)
- File names or packages
- HTTP status codes or headers
- Database column or table names
- Framework or library internals

**Group by user feature or outcome**, not by layer (backend/frontend/test).

**Good:** "Users can sign in with just their email — no password needed"
**Good:** "Rate limiting on sign-in to prevent abuse"
**Acceptable:** "Session fixation prevention on authentication"
**Bad:** "Added POST /api/auth/start endpoint with Bucket4j rate limiting"
**Bad:** "AuthController now uses tryConsumeAndReturnRemaining for Retry-After header"
**Bad:** "Frontend httpClient now uses credentials: include"

If a bullet would make sense only to someone who has read the diff, it is too technical.
Rewrite it as the *outcome* that diff enables.

**Group** related work into one bullet per theme. One bullet per file or class is always wrong.

### Additional Changes — Out-of-Band Work Only

This section is for changes that are **disjoint from the key changes** — not a subset of
them. Think: an unrelated refactoring that added value, or a fix for something outside
the feature scope that was the right time to address.

If something was part of building the feature (bug fixes during development, test
builder cleanup, seed data corrections), it belongs in the diff, not in the commit
message. The reviewer wouldn't ask "why is this here?" so don't call it out.

### Validation / Quality — Outcome-Level Reporting

State what behavior was covered and whether the relevant automated checks passed.
Keep the section readable for product and engineering stakeholders.

Required fields:

- **Test focus:** one high-level line naming the use cases or behavior areas
  that received test attention. Do not list file names, test method names, or
  test counts.
- **Automated tests:** one line with the pass/fail outcome plus the kinds of
  automated coverage added or updated, such as unit, integration, or E2E tests
  for a named behavior area.

Optional fields:

- **Manual tests:** include only manual QA that the human explicitly requested
  or performed. Keep it brief and outcome-focused.
- **Findings:** include only bugs or quality issues found during QA that were
  fixed immediately or recorded for follow-up.

Omit optional fields when they do not add useful information. No commands, file
inventories, tool flags, or raw test counts. The reader cares about the
guarantee, not the keystrokes.

---

## Self-Review Checklist

Before finalizing a commit message, verify:

- [ ] Can I explain this commit in one sentence to a product person?
- [ ] Is the language at the level of a senior manager briefing product, with no AI vernacular ("lifts", "wires up", "stable anchor"), developer slang ("DX", "first-class", "plumbing"), internal labels ("I9", "M3"), or process meta-commentary ("this commit", "in the next PR")?
- [ ] Does every Key Changes bullet describe a *user outcome or product capability*, not a file/class/method/route?
- [ ] Does any bullet contain a route path, class name, method name, or HTTP header? If yes, rewrite or remove it.
- [ ] Would removing any bullet lose information a reviewer needs? If not, remove it.
- [ ] Is the total message under 30 lines?

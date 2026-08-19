---
name: review-code
description: Review a diff on four independent axes — Standards (this project's written rules), Design (principles and smells), Spec (what the issue asked for), and Correctness (bugs, via the built-in /code-review). Use when the user says "review esto", "revisa el diff", "review the branch", or after /implement. Pass one axis name to run just that one. Reports separate blocks and refuses to rank them against each other.
disable-model-invocation: true
---

# Review code

Four questions, answered independently:

| Axis | Question | Cites |
|---|---|---|
| **Standards** | Does it follow the rules this project wrote down? | A `CLAUDE.md` line |
| **Design** | Is it well designed? | A principle or smell |
| **Spec** | Does it do what the issue asked? | A line of the spec |
| **Correctness** | Does it have bugs? | The built-in `/code-review` |

Code passes one and fails another all the time. They run separately, report separately, and
are never merged or ranked against each other.

Short and to the point. **Report only** — fix nothing unless the user asks.

An axis name as argument (`/review-code design`) runs only that axis.

## Step 1 — Fix the point of comparison, then gate

You need a ref: a commit, branch, tag, `main`, `HEAD~5`. Default to the branch point off
`main`; ask if that's wrong.

Check it. Invalid ref or empty diff → say so and stop. Don't spawn agents to review nothing.

Then run the test suite once, plus whatever `CLAUDE.md`'s Verification section requires. Red
suite or failed verification → report which tests fail and stop; reviewing a red diff wastes
four agents. The user can override with "review anyway".

Skip the run if the suite already passed in this session and nothing changed since — you just
ran it in `/implement`.

## Step 2 — Run the axes, one subagent each

Separate contexts, so no axis contaminates another's reasoning. The axes read; they never run
anything.

### Standards

Read `CLAUDE.md` — Code Style, Boundaries, Glossary, Verification — and check the diff against
it. A Boundaries violation is the most serious thing this review can report.

Always in scope for this project:

- **Functional by default** unless `CLAUDE.md` says otherwise.
- **Names come from the glossary**, in types, fields and modules alike.
- **A permission-gated control gates itself on the client.** Server guard present, button
  visible to users who lack the permission → 🔴.
- **No control without a backend that honors it.** A button that errors out, a fake URL, an
  unregistered provider → 🔴. Don't ship lies.

Every finding cites the `CLAUDE.md` line plus the hunk. No citation, no finding.

### Design

Detect language and framework first (extensions, imports, config) and keep every suggestion
idiomatic to that ecosystem — Pythonic, Go errors-as-values, narrow TS types. Don't impose
another language's style.

Judge the diff's own code — not the code it merely touches — against:

- **SOLID** — one reason to change, open/closed, honest subtypes, no fat interfaces, depend on
  abstractions.
- **DRY** — duplicated logic, magic numbers, repeated literals.
- **Clean Architecture** — dependencies inward; no ORM, HTTP or framework types in business
  logic.
- **Clean Code** — meaningful names, small functions, no dead code, comments explain *why*,
  low nesting.
- **KISS / YAGNI** — the simplest thing that works; no speculative generality.
- **Smells** — long function, large class, feature envy, primitive obsession, shotgun surgery,
  god object, premature abstraction.

Per finding: the snippet, one line on why it bites, and a concrete refactored snippet. Skip 🟢
polish unless asked — at this depth it's noise.

This axis cites a principle, never a `CLAUDE.md` line. If the project wrote a rule about it,
it belongs to Standards, and Standards wins.

### Spec

Read the issue (`gh issue view`, repo from `CLAUDE.md`'s Issues section) or the spec in the
conversation. Then check the diff against it:

- **Missing** — a user story with no code behind it.
- **Partial** — the happy path landed, an explicit requirement didn't.
- **Wrong** — implemented, but not what the story described.
- **Out of scope shipped anyway** — the issue's Out of Scope section is a requirement, not a
  suggestion. Violating code is a finding even when the code is good.

Every finding cites the line of the spec it fails.

**Prototype slices are judged differently.** A `/to-prototype-spec` issue lists what is
deliberately hollow; those stubs are the spec, not a violation of it. Judge the interface and
the stub contract, nothing else.

### Correctness

Run the built-in `/code-review` on the same ref. It hunts bugs, which no axis above does.
Report its findings as their own block, unmerged like the rest.

## Step 3 — Report

One block per axis. Never interleaved, never one list.

- 🔴 **Critical** — a `CLAUDE.md` rule broken, or a spec requirement missing or wrong.
- 🟡 **Warning** — a real smell that will bite. Fix soon.
- 🟢 **Suggestion** — polish.

Close with **the worst issue per axis**, one line each. Do not name an overall winner: a clean
diff that doesn't do what the issue asked is not better or worse than a working diff written
badly. Different failures — the user decides which one matters today.

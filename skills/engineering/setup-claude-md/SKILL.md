---
name: setup-claude-md
description: Create or update a project's CLAUDE.md by interrogating what the code can't tell you. Use when a repo has no CLAUDE.md, when the user says "set up CLAUDE.md", "update CLAUDE.md", "document this project for Claude", or when an existing one has drifted from the code. Derives everything derivable from the repo, asks only what requires judgment, and proposes the file before writing it.
disable-model-invocation: true
---

# Set up CLAUDE.md

`CLAUDE.md` is loaded into every session in this repo. That makes it expensive: every line
costs context in every future conversation. Write only what a competent stranger could not
work out from the code in a minute — and no more.

Short and to the point. **Write nothing** until the user confirms the proposal.

## Step 1 — Derive first, ask second

Read the repo before asking anything. `package.json` / `pyproject.toml` / `go.mod`, the
lockfile, scripts, CI workflows, the top two levels of directories, `git log` and branch
names, existing config. Fan out read-only agents.

**Finding facts is your job, never the user's.** Versions, script names, and directory
layout come from the repo. What you ask about is judgment: intent, conventions, and the
things people get wrong.

If a `CLAUDE.md` already exists, read it and check it against the code. Drifted lines are
worse than missing ones — a stale claim gets trusted. Propose edits to the drifted parts;
don't rewrite the file wholesale.

## Step 2 — Interrogate in rounds

Ask only what the code can't answer, a round at a time, in `/explore-plan` format:

❓ **Q[#]** — **<title>**: <options and the real trade-off>

➡️ <your recommendation>

Always recommend. Skip anything you already derived — state it as a finding instead.

The questions worth asking, in the order the file will carry them:

- **Business** — what does this do, for whom, and what makes a moment of use good? The
  user roles, and the rules of the domain that must always hold. The code cannot tell you
  any of this, and every design decision downstream depends on it.
- **Glossary** — only terms the code names inconsistently or ambiguously (`user_id` in the
  DB, `customerId` in the API). A term already consistent everywhere documents itself.
- **Tech stack** — why these choices, and which architecture patterns are in play (DDD,
  event-driven, hexagonal, layered)? Versions you derive; the *why* only they know.
- **Code style** — **functional by default**: pure functions, immutable data, composition
  over inheritance, declarative `map`/`filter`/`reduce`, small files. Ask only whether this
  project departs from that, and where.
- **Project structure** — which directories does someone actually need to know about, and
  the one-line purpose of each? Two levels deep, no deeper.
- **Commands** — which of the scripts you found actually matter day to day? Any command
  that looks obvious but is wrong (a `dev` that must run behind a proxy, a test runner that
  needs a service up)? Env vars and deploy go here as single lines, not as sections.
- **Git workflow** — branch naming (**`feat/` by default**, plus `fix/`, `chore/` or
  whatever they use), PR conventions, what CI gates a merge. Check `git log` and existing
  branches first; the repo usually already answers this.
- **Verification** — how do you know a change works, before claiming it does? The
  stale-build trap, the rebuild step people forget, the check CI runs and you don't.
- **Boundaries** — *what should never happen here?* The most valuable section and the one
  they haven't thought about. Prompt with the scars: what broke before, what shouldn't be
  touched without asking, what looks safe and isn't.
- **Issues** — repo and project board where issues go, and the label vocabulary.
  `/to-specs` and `/to-prototype-spec` read this; without it they ask every run.

Stop asking when the answers stop changing what would be written.

## Step 3 — Draft it

```markdown
# <project>

<one line: what this is>

## Business
## Glossary
## Tech Stack
## Code Style
## Project Structure
## Commands
## Git Workflow
## Verification
## Boundaries — never do this
## Issues
```

Rules for the prose:

- **One claim per line, imperative.** "Rebuild `@x/core` before verifying the app" beats a
  paragraph about build caching.
- **Say why when the why is the point.** A rule with no reason gets argued with or ignored.
- **No section for its own sake.** Nothing to say about the git workflow beyond `feat/`?
  Then that's the whole section, one line.
- **Never restate the code.** No dependency lists, no file trees deeper than two levels, no
  function inventories. They rot, and the code already says it.
- **Never duplicate the global `~/.claude/CLAUDE.md`.** Include a project rule only where it
  *differs* from the global one, and say that it differs.

## Step 4 — Propose, then write

Show the draft in full, plus a one-line note per section on what you derived vs. what they
told you — that's where errors hide.

Then **wait for explicit confirmation** before writing the file.

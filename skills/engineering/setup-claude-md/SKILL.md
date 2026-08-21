---
name: setup-claude-md
description: Create or update a project's CLAUDE.md by interrogating what the code can't tell you. Use when a repo has no CLAUDE.md, when the user says "set up CLAUDE.md", "update CLAUDE.md", "document this project for Claude", or when an existing one has drifted from the code. Derives everything derivable from the repo, asks only what requires judgment, and proposes the file before writing it.
disable-model-invocation: true
---

# Set up CLAUDE.md

`CLAUDE.md` is loaded into every session in this repo. That makes it expensive: every line
costs context in every future conversation. Write only what a competent stranger could not
work out from the code in a minute — and no more.

Short and to the point. **Write nothing.** Not the file, not a draft on disk — nothing,
until the user says to save it. Approving the content is not the same as asking you to
save it.

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

Ask only what the code can't answer, a round at a time, in `/explore-idea` format:

➡️ **Q[#]** — **<title>**: <options and the real trade-off>

Recommendation: <your recommendation>

Always recommend. Skip anything you already derived — state it as a finding instead.

The questions worth asking, in the order the file will carry them:

- **Business** — what does this do, for whom, and what makes a moment of use good? The
  user roles, and the rules of the domain that must always hold. The code cannot tell you
  any of this, and every design decision downstream depends on it.
- **Glossary** — only terms the code names inconsistently or ambiguously (`user_id` in the
  DB, `customerId` in the API). A term already consistent everywhere documents itself.
- **Tech stack** — why these choices, and which architecture patterns are in play (DDD,
  event-driven, hexagonal, layered)? Versions you derive; the _why_ only they know.
- **Code style** — **functional by default**: pure functions, immutable data, composition
  over inheritance, declarative `map`/`filter`/`reduce`, small files. Ask only whether this
  project departs from that, and where. Plus **testing**: what a good test looks like here,
  which seams are the agreed boundaries, and the anti-patterns they keep seeing. Whatever
  lands here is what `/review-code`'s Standards axis will enforce, citing it — a testing rule
  nobody wrote down is a rule nobody checks.
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
- **Boundaries** — _what should never happen here?_ The most valuable section and the one
  they haven't thought about. Prompt with the scars: what broke before, what shouldn't be
  touched without asking, what looks safe and isn't.
- **Issues** — repo and project board where issues go, and the label vocabulary.
  `/plan-tasks` and `/plan-prototype-tasks` read this; without it they ask every run.

Never run out of questions. Once the section list above is covered, the next round goes
deeper: contradictions between what they told you and what the code does, rules they
follow without noticing, sections that read as filler and should be cut. There is always
another round — ending this is the user's call, not yours.

## Step 3 — Draft, show, ask again

Every round, in this order:

1. **The sections you touched, in full.** Not diffs, not summaries. Leave the untouched
   sections out — show the whole file only when the user asks for it.
2. **What changed** since the last round. One line.
3. **The next round of questions.**

Then loop. An answer sharpens one section, which usually opens a question about another —
keep going. Rounds get cheaper as the draft settles; a late round that costs one question
and changes one line is normal and still worth running.

The shape:

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
  _differs_ from the global one, and say that it differs.

## Step 4 — Save only when told

Write the file **only** when the user explicitly says to save it — "save", "guarda",
"escríbelo", "write it". Nothing else counts: not "looks good", not "perfect", not
approving a section, not silence after a draft. Those mean the draft is right so far, and
the next round starts.

Until then the draft lives in the conversation only.

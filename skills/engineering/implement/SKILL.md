---
name: implement
description: Build an already-decided epic, one task at a time. Use when the user says "implementa el epic", "implementa esto", "hazlo", or hands over an issue to build. No interview and no replanning — what was settled upstream is the input. Coordinates one subagent per task, sequentially, TDD at the agreed seams. Never commits.
disable-model-invocation: true
---

# Implement

The work was already decided — by `/to-specs`, by an issue, or above in the conversation.
**No interview, no clarifying round, no proposing a different approach.** If a task is
genuinely wrong, say so in two lines and stop; don't quietly redesign it.

You are the coordinator. You hold the epic and the order; each task's code lives in its own
subagent, so your context stays small and theirs stays focused.

Short and to the point.

## Step 1 — Before anything

- **The epic.** Restate it in one line: what will be usable when this lands. List the tasks
  in the order you'll run them.
- **The branch.** On `main`? Propose one and wait — `feat/` for new capability, `fix/` for a
  bug, `chore/` for the rest, or whatever prefixes `CLAUDE.md`'s Git Workflow names. Never
  commit, never rebase, never amend.
- **`CLAUDE.md`.** Read Code Style, Glossary, Verification, Boundaries. Subagents inherit
  this file, so you don't repeat it to them — but you need it to judge their output.

## Step 2 — Order the tasks

Dependency order, as the epic lists them. **Sequential, one at a time** — vertical slices in
one epic usually touch the same modules, migrations and i18n files, and parallel agents on
one working tree corrupt each other's work.

**A prototype task runs first and alone.** Its acceptance is the user's sign-off on the
experience, not tests. Stop the epic there and wait for it.

## Step 3 — Run each task

One subagent per task. Hand it: the task, its seams, its out-of-scope, and what the previous
task changed. Nothing else — it reads `CLAUDE.md` itself.

Its contract:

- **Red before green.** The failing test first, then only enough code to pass it. No
  speculative features.
- **Vertical slices.** One seam → one test → one implementation → repeat. Never all the tests
  up front: bulk tests verify imagined behavior and go blind to real changes.
- **Only pre-agreed seams**, at public boundaries — never internals, never private methods.
  No seams in the spec? Ask the user once, before writing code.
- **Expected values from an independent source** — a known-good literal, a worked example, the
  spec. Never recomputed the way the code computes them.
- **Tests read like specifications**, named in the project's glossary terms.
- **No refactoring inside the loop.** That belongs to the review stage.
- **A permission-gated control gates itself on the client too.** If the mutation is guarded
  server-side, the button hides or disables for users lacking the permission. Part of the
  task, not polish.
- **Out of scope holds**, even when adjacent code is obviously improvable. Report it, don't
  fix it.
- **Typecheck and run its own test file. Never the full suite. Never commit.**

## Step 4 — Between tasks

Run the full suite yourself, after each task. That's where you catch task 2 breaking task 1 —
the subagent can't see it, it only ran its own file.

Then do what `CLAUDE.md`'s Verification section says. A green typecheck against a stale build
proves nothing; if there's a rebuild step, run it before believing anything works.

Read the tests the task added, before starting the next one. The agent that wrote them can't
judge them, and this is the cheapest moment to fix them — nothing depends on them yet. Reject
an assertion that recomputes the expected value the way the code does, a test reaching into
internals instead of the agreed seam, or a mock of an internal collaborator.

Red suite? Fix it, or send it back to a fresh subagent with what failed. Never start the next
task on a red suite.

## Step 5 — Close

Run `/review-code` on the diff and fix what it finds.

Then **stop.** Report: what each task changed, what you verified and how, what you left out
and why.

**Do not commit.** Not when the tree is clean, not when the tests pass, not when it feels
finished. The user commits, or says to.

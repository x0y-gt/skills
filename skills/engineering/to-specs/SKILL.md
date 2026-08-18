---
name: to-specs
description: Turn a settled design into an epic with spec'd sub-issues in the project's tracker. Use after /explore-plan and /design-model, or when the user says "break this into issues", "create issues for this", "spec this out". Reads CLAUDE.md to find where issues go, synthesizes from the conversation instead of re-interviewing, and cuts every issue as a usable slice rather than a layer.
disable-model-invocation: true
---

# Spec into issues

The design is settled. Turn it into an epic and its slices. **Synthesize, don't
interview** — the conversation already happened; if something is genuinely undecided,
list it as an open question instead of restarting the design.

Short and to the point, in what you say and in what you write into the issues.

**Create nothing** until the user confirms the breakdown.

## Step 0 — Does this need a prototype first?

If the work has real UX/UI and no prototype has been signed off yet, stop and use
`/to-prototype-spec` instead. Speccing slices against an interface that hasn't been seen
means respeccing them after it changes.

Already have a signed-off prototype? Its stub contract is your starting data contract,
and its hollow pieces are your slice list.

## Step 1 — Find the tracker

Read `CLAUDE.md` for where issues go: repo, project board, label vocabulary, required
template.

Not declared? Ask once — repo and board — and propose an `### Issues` section for
`CLAUDE.md` so the next run doesn't ask. Propose it; don't write it.

Also from `CLAUDE.md`: the glossary (issues use the project's terms) and any ADRs the work
touches (don't re-decide what's decided).

## Step 2 — Cut by moment of use

The interface is the product; the domain model and infra exist to serve it. That dictates
the cuts:

- **Every issue delivers a usable moment**, not a layer. Vertical slices — never "all the
  DB" then "all the UI".
- **No issue leaves a control its backend can't honor.** Per control, answer: *what
  happens when a user clicks this in production, with the code this issue leaves behind?*
  "Errors out", "fake URL", "no provider registered" → the cut is wrong. (The prototype is
  the one exception, and it's flagged off.)
- **A permission-gated control carries its client-side gate as acceptance criteria.** If
  the mutation is guarded server-side, the button must hide or disable itself for users
  without the permission. The server guard stays the source of truth, but a control that
  403s is the same broken promise as a fake URL. Requirement, not polish.
- **Replacing a stub is part of a slice, never its own issue.** "Wire up the real backend"
  delivers nothing on its own; fold it into the slice whose moment it completes.

The floor: don't ship lies. The ceiling: someone designed the moment of use before the
schema.

## Step 3 — Shape the epic

**Epic** — one issue naming the moment of use and the outcome. Short body, plus a
checklist linking the sub-issues in dependency order. No implementation detail; that
lives in the sub-issues.

**Sub-issues** — one per slice, only when there's more than one. A single-slice change is
one issue, not an epic with one child.

If a prototype epic already exists, add the slices to it instead of opening a new one.

## Step 4 — Testing seams

Per slice, where the tests attach. Prefer seams that already exist; put them at the
highest level that still fails for the right reason. Show the seams before writing specs —
a wrong seam invalidates the spec below it.

## Step 5 — Write the specs

Per issue, only the sections that carry weight:

- **Problem** — from the user's perspective.
- **Solution** — from the user's perspective.
- **User stories** — `As a <role>, I want <x>, so that <y>`, numbered. Generous here; this
  is where scope stops being ambiguous.
- **Implementation decisions** — modules, interfaces, choices. No file paths: they rot,
  and they let the implementer skip thinking.
- **Testing decisions** — the seams, what "good" means, prior art to copy.
- **Out of scope** — explicit. This is what holds during implementation.
- **Open questions** — empty is the goal.

## Step 6 — Confirm, then create

Present the breakdown first: one line per issue, dependency order, what each makes usable.
Get confirmation.

Then create via `gh`: epic (or the existing one), sub-issues linked to it, labels from Step
1, all on the board. Report numbers and URLs, nothing else.

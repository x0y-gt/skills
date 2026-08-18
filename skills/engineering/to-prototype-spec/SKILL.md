---
name: to-prototype-spec
description: Spec a prototype-first slice when the work has real UX/UI — a complete interface plus a skeletal backend, in one small PR, meant to be iterated on before the real slices are specced. Use before /to-specs whenever the design touches screens the user will look at, or when the user says "prototype this", "let's see it first", "mock it up". Creates the epic and this one issue, nothing else.
disable-model-invocation: true
---

# Spec a prototype

The design is settled and it has real UX/UI. Before speccing the work, spec **one small
prototype** to iterate the interface on.

Short and to the point. **Create nothing** until the user confirms.

## Why this comes first

> "You've got to start with the customer experience and work backwards to the
> technology." — Steve Jobs

The interface is the product; the settled interface is also what defines the data
contract. Spec the backend against a UI that's still moving and you rebuild it on every
iteration.

## Step 1 — Find the tracker

Read `CLAUDE.md` for where issues go: repo, project board, labels, required template. Not
declared? Ask once, and propose an `### Issues` section for `CLAUDE.md` — propose, don't
write. Use the project's glossary terms, and respect existing ADRs.

## Step 2 — Scope the prototype

**Complete UI, skeletal backend, one small PR.**

- **The interface is real.** Every screen and state the moment of use needs — empty,
  loading, error, populated. This is the part being judged.
- **The backend is the minimum that holds the UI up.** Endpoints/resolvers that return
  fixed or trivially-derived data. No business logic, no migrations beyond what the shape
  demands, no edge cases.
- **Not reachable in production** — behind a flag, or simply not linked from the nav. A
  control that answers with fake data is still a lie; the flag is what keeps it honest.
- **Small enough to redo.** If it can't land in one modest PR, cut the moment of use
  narrower — one flow, not the whole feature.

Name explicitly what is hollow. An unnamed stub becomes permanent.

## Step 3 — Write the issue

- **Problem** — from the user's perspective.
- **The moment of use** — what the user does, start to finish, in a few lines.
- **Screens and states** — the list from Step 2.
- **Stub contract** — the shape each stub returns. This is the draft data contract the
  real slices will inherit, so it's the part worth thinking about.
- **Deliberately hollow** — every piece with no logic behind it, listed.
- **Out of scope** — explicit.
- **Acceptance** — the user signs off on the experience. Not tests; there's nothing
  stable to test yet.

## Step 4 — Create the epic and this issue only

Confirm the scope, then via `gh`: the epic (the moment of use, the outcome, a checklist
with this issue first), plus the prototype issue linked to it. Labels from Step 1, both
on the board.

**Stop there.** The remaining slices get specced by `/to-specs` once the prototype is
signed off — anything written now is a guess about an interface that is about to change.
Say so in the epic.

Report numbers and URLs, nothing else.

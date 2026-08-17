---
name: design-model
description: Turn an understood problem into a domain model and module boundaries before writing code. Use after the problem is settled (e.g. after /explore-plan) or when the user says "how should we model this", "where do these boundaries go", "let's design this", or is about to start building. Derives the ubiquitous language from the code, stress-tests it with concrete scenarios, draws boundaries using design principles, and proposes ADRs only for hard-to-reverse trade-offs.
disable-model-invocation: true
---

# Design the model

The problem is understood and the scope is already trimmed. Now settle the *language*
and the *boundaries*.

**Write nothing.** No code, no files. Everything below is a proposal; you write only
what the user confirms at the close.

Design principles here are a **design criterion, not a review**: they decide where the
seams go. Auditing written code is `/best-practices`, later.

## Step 1 — Settle the ubiquitous language

The domain language must be one language: the same term in the conversation, in the
code, and in the database. Find out what that language currently is, and make it
consistent.

**Read the code first.** It is the only source that cannot be out of date. Fan out
read-only agents over type and model names, DB tables and columns, API field names,
event names, module names. If `CLAUDE.md` has a glossary, read it too — as a claim to
verify against the code, not as the truth. Most repos have no glossary; that is the
normal case, not a blocker.

Report the working language you found, then challenge it:

- **One concept, several names.** `user_id` in the DB, `customerId` in the API,
  `accountRef` in the frontend — one concept or three? Which name wins?
- **One name, several concepts.** If *order* is the cart in one module and the paid
  record in another, that ambiguity lands in your design. Split it, name both.
- **Fuzzy terms.** "You say *account* — the Customer or the User? Different things."
- **Code vs. claim.** If the user says how something works and the code disagrees,
  surface the contradiction.

Only what the user alone knows goes to the user: which name is canonical, and what the
term means to the business. Everything else you look up yourself.

Track the terms you resolve — they become a proposed `CLAUDE.md` glossary at the close.
Keep it to terms the code got wrong or ambiguous; a term already consistent everywhere
needs no entry.

## Step 2 — Stress-test with concrete scenarios

Invent specific scenarios that probe the edges and force precision about where one
concept ends and the next begins. Vague agreement on abstract terms is the failure mode
this step exists to catch.

## Step 3 — Draw the boundaries

Propose the module/layer shape, justified by principle — not by taste:

- **One reason to change** per module (SRP). If two forces would rewrite it, split it.
- **Dependencies point inward** (domain → use cases → adapters → infra). No framework,
  ORM, or HTTP type in business logic.
- **Depend on abstractions** only where a second implementation is real, not imagined.

Scope was already cut in the plan step — don't relitigate it here. Adapt to the
ecosystem's idioms (detect from imports and config); don't import another language's
structure.

Sketch it — a small tree or a list of modules with their one responsibility and what
they may depend on. Name every module, type, and field with a term from the settled
language.

## Step 4 — Flag decisions worth an ADR

A decision earns an ADR only when all three hold:

1. **Hard to reverse** — changing your mind later costs real work.
2. **Surprising without context** — a future reader will ask "why this way?"
3. **A real trade-off** — there were genuine alternatives and you picked one.

Miss any one and skip it. List the ones that qualify; don't draft them yet.

## Close — the proposal

Present, in this order, nothing longer than it needs to be:

1. **Language** — the settled terms, and the renames the existing code needs to speak
   them. A language isn't ubiquitous until the code uses it.
2. **Boundaries** — the module sketch.
3. **To write on confirmation** — the `CLAUDE.md` glossary entries, and the ADRs
   (`docs/adr/NNNN-slug.md`) worth recording.
4. **Open assumptions.**

Then stop and **wait for explicit confirmation** of shared understanding before
proposing any action.

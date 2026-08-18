---
name: explore-plan
description: Interrogate a plan round by round until nothing is silently assumed — building it from scratch if there isn't one yet. Closes with the decisions settled and the assumptions still open: the groundwork before planning, not the plan itself. Use when the user says "crea un plan", "haz un plan", "planifica esto", "create a plan", "make a plan", "plan this out", "grill me on this", "poke holes in this plan", "what am I missing", or hands over a plan to sharpen before building. Not for a one-line ask or a trivial change. Asks the answerable questions in rounds, always with a recommendation, and researches facts itself instead of delegating them back to the user.
---

# Explore a plan

Interrogate the plan until no assumptions are left hidden — and if there is no plan yet,
the rounds are how it gets built. Same frontier, same format: you're filling an empty tree
instead of auditing a full one. Do not implement anything.

Every decision opens the decisions that hang off it. The **frontier** is the set of
decisions whose prerequisites are already settled: ask only those, in rounds, and move
to the next layer once the user answers.

Format:

➡️ **Q[#]** — **<title>**: <options and the real trade-off>

Recommendation: <your recommendation>

- Always give your recommendation. An interrogation without a stance is a survey.
- **Finding facts is your job, never the user's.** If a question can be answered by
  reading the code or the environment, go find out — fan out read-only agents and keep
  working other branches while they come back. Only ask what the user alone knows:
  intent, priorities, business constraints.
- If you can infer the answer from context, state it as an assumption and move on. No
  filler questions.
- **Challenge scope by principle, not by taste.** YAGNI: which part of the plan exists
  for an imagined requirement? DRY: does the repo already do some of this — go find out,
  don't ask. KISS: is there a simpler version that solves the same problem? These three
  shrink scope; leave the structure-generating principles (layering, interfaces) to the
  design step, or you get speculative architecture before the problem is settled.

You are done when the frontier is empty. Summarize the decisions made and the
assumptions still open, then **wait for explicit confirmation** of shared understanding
before proposing any action.

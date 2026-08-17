---
name: explore-plan
description: Interrogate a plan or design round by round until nothing is silently assumed. Use when the user says "grill me on this", "poke holes in this plan", "what am I missing", "stress-test this design", or hands over a plan they want sharpened before building. Asks the answerable questions in rounds, always with a recommendation, and researches facts itself instead of delegating them back to the user.
disable-model-invocation: true
---

# Explore a plan

Interrogate the user's plan until no assumptions are left hidden. Do not implement
anything.

Every decision opens the decisions that hang off it. The **frontier** is the set of
decisions whose prerequisites are already settled: ask only those, in rounds, and move
to the next layer once the user answers.

Format:

❓ **Q[#]** — **<title>**: <options and the real trade-off>

➡️ <your recommendation>

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

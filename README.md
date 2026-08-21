# skills

Claude Code skills for taking work from idea to reviewed code.

## The pipeline

| Skill | Does | Ends when |
|---|---|---|
| `/explore-idea` | Interrogates the plan round by round. Cuts scope (YAGNI, DRY, KISS). | Nothing is silently assumed. |
| `/design-model` | Settles the ubiquitous language from the code, draws module boundaries (SRP, dependency direction). | Terms and boundaries agreed. |
| `/plan-prototype-tasks` | Epic + one issue: complete UI, skeletal backend, one small PR. **Only if the work has UX/UI.** | Prototype issue created. |
| `/plan-tasks` | The remaining slices, spec'd and cut by moment of use. | Issues on the board. |
| `/implement` | Builds the epic — one subagent per task, sequentially, TDD at the agreed seams. | Tasks done, suite green. |
| `/review-code` | Reviews the diff on four axes: Standards, Design, Spec, Correctness. | Findings reported per axis. |

Skip `/plan-prototype-tasks` when there's no interface. Otherwise run it first and spec the
rest after the prototype is signed off — the settled interface defines the data contract.

## Before the pipeline

`/setup-claude-md` builds the project's `CLAUDE.md` by asking what the code can't answer.
Every skill above reads it — glossary, code style, verification steps, boundaries, and where
issues go — so it's worth doing once per repo before anything else.

## Rules they share

- Nothing gets written or created until you confirm it.
- Facts are the skill's job, not yours — it reads the code instead of asking.
- Scope-reducing principles in the plan step (YAGNI, DRY, KISS), structure-generating ones in
  the design step (SRP, dependency direction), and both again as review axes at the end.
- Nothing commits. You do.

## Install

Symlink the skills into `~/.claude/skills`:

```bash
./scripts/link-skills.sh
```

Edit any `SKILL.md` and the next session picks it up — no copying, nothing to keep in
sync. Re-run it after adding a skill or moving the repo.

It refuses to clobber real directories, so stale `cp` copies are reported instead of
overwritten. Pass `--force` to replace them. Set `CLAUDE_SKILLS_DIR` to link somewhere
else.

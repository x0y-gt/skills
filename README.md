# skills

Claude Code skills for taking work from idea to issues.

## The pipeline

| Skill | Does | Ends when |
|---|---|---|
| `/explore-plan` | Interrogates the plan round by round. Cuts scope (YAGNI, DRY, KISS). | Nothing is silently assumed. |
| `/design-model` | Settles the ubiquitous language from the code, draws module boundaries (SRP, dependency direction). | Terms and boundaries agreed. |
| `/to-prototype-spec` | Epic + one issue: complete UI, skeletal backend, one small PR. **Only if the work has UX/UI.** | Prototype issue created. |
| `/to-specs` | The remaining slices, spec'd and cut by moment of use. | Issues on the board. |

Skip `/to-prototype-spec` when there's no interface. Otherwise run it first and spec the
rest after the prototype is signed off — the settled interface defines the data contract.

## Rules they share

- Nothing gets written or created until you confirm it.
- Facts are the skill's job, not yours — it reads the code instead of asking.
- Scope-reducing principles in the plan step, structure-generating ones in the design
  step, code review (`/best-practices`) after.

## Install

```bash
cp -r skills/engineering/* ~/.claude/skills/
```

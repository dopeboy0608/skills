# Strategy presets (slot: large-task workflow)

The user picks exactly one strategy for large tasks during the interview. Each option has a fragment file in this folder; the fragment is the only place that describes that strategy's artifact locations and sub-task rules. Common documents only delegate ("follow the selected strategy skill").

| Name | Marker value | Skill the user runs (`{{STRATEGY_SKILL}}`) | Call argument | Needs setup | Artifacts | Target stack | Fragment |
|---|---|---|---|---|---|---|---|
| `feature-strategy` | `feature-strategy` | `feature-strategy` | issue number, title, body summary | `dopeboy0608-skills` plugin only | `docs/feature/<issue>-<slug>.md`, sub-issues | Frontend, full-stack | `feature-strategy.md` |
| `speckit` | `speckit` | `speckit.specify` (then `speckit.plan`, `speckit.tasks`, `speckit.implement`) | feature description built from the issue | Spec Kit CLI (`specify`) + `specify init --here --integration claude` | `specs/<NNN-slug>/`, `.specify/` | Any (backend-friendly) | `speckit.md` |
| Direct input | `custom:<skill-name>` | the name the user types | issue number, title, body summary | whatever that skill needs (the user does it) | defined by that skill | Any | `custom.md` |
| None | `none` | — | — | nothing | none | Any | `none.md` |

## Default recommendation by stack

Ask the tech stack first (interview question 2); the recommendation for question 6 depends on it.

| Stack | Recommend first | Also offer |
|---|---|---|
| Frontend / full-stack | `feature-strategy` | `speckit`, direct input, none |
| Backend only | `speckit` | direct input, none; say `feature-strategy` is a frontend-oriented skill (design, mocks, UI sub-tasks) but still available |

The user's choice always wins, including `feature-strategy` on a backend-only stack. If the stack is "not decided", ask frontend / backend / full-stack before recommending.

## Fragment contract

Every fragment defines these slot values, using the same section names as `feature-strategy.md`:

- `{{STRATEGY_SKILL}}` — substituted in exactly two places: the large-task bullet of CLAUDE.md and step 6 of `issue-start`.
- `{{STRATEGY_INVOKE_NOTE}}` — one sentence for `issue-start` about how the command is spelled in a plugin install (empty when not applicable).
- `{{STRATEGY_RULES}}` — the "Workflow rules" block written into CLAUDE.md.
- `{{STRATEGY_TRACKER_NOTES}}` — the "GitHub issue mapping" block (empty when none).
- The marker value, and the "Requires" line for the post-generation summary (which skill/tool must be installed for the large-task path to work).

Setup-time hooks for each strategy are in `ai-workflow-setup/references/strategy-hooks.md`, not here.

## Rules for the common documents

- A strategy that was not selected leaves **no trace** in generated files: no name, no artifact path, no install note. Do not copy another fragment's sentences into the common templates.
- The `none` option removes the large-task path entirely (see `none.md`); the other three keep the A/B routing.

## Adding a preset later

1. Add a row above and a fragment file with the contract's sections.
2. Add its hook to `ai-workflow-setup/references/strategy-hooks.md`.
3. Nothing else in `core/` or `project-skills/` changes: they only use the slots above.

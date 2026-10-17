# Strategy presets (slot: large-task workflow)

The user picks exactly one strategy for large tasks during the interview. Each preset has a fragment file in this folder; the fragment is the only place that describes that strategy's artifact locations and sub-task rules. Common documents only delegate ("follow the selected strategy skill").

| Name | Skill to invoke (`{{STRATEGY_SKILL}}`) | Target stack | Needs setup | Fragment |
|---|---|---|---|---|
| `feature-strategy` | `feature-strategy` (plugin form: `dopeboy0608-skills:feature-strategy`) | Frontend, full-stack | None beyond the `dopeboy0608-skills` plugin | `feature-strategy.md` |

Only one preset is available in this version. Offer it as the default; if the stack is backend-only, say it is a frontend-oriented skill and let the user decide (the user's choice wins). Other options (direct input, none) are not supported yet: if the user asks for one, say so and stop instead of improvising.

## Adding a preset later

1. Add a row above and a fragment file with the same sections as `feature-strategy.md`.
2. Nothing else in `core/` or `project-skills/` changes: they only use the slots `{{STRATEGY_SKILL}}` and `{{STRATEGY_RULES}}`.

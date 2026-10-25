# Preset fragment: none (no large-task strategy)

Not offered for a frontend-only stack (see `presets.md`). The user does not want a separate large-task workflow. Every issue is implemented directly. This option removes the large-task path from the generated files instead of leaving a dead branch.

## Slot values

- No `{{STRATEGY_SKILL}}`, `{{STRATEGY_RULES}}`, `{{STRATEGY_PRECHECK}}`, `{{STRATEGY_INVOKE_NOTE}}` or `{{STRATEGY_TRACKER_NOTES}}`: delete the places that use them as described below. No `{{` may remain.
- Marker value: `strategy=none`.
- Requires (for the summary): nothing; say that large issues are not routed anywhere and the user should split them into smaller issues first.

## Changes to the common templates

| File | Change |
|---|---|
| `core/claude-md.md` | Drop the **Large task** bullet and the `{{STRATEGY_RULES}}` block. Reword the intro to "it reads the issue, prepares the branch, and starts implementation; the user always makes the final choice" and drop the sentence about two paths and recommendation criteria. |
| `core/architecture.md` | Replace "Task routing criteria" with one paragraph: all issues are implemented directly; if an issue looks too big or ambiguous, tell the user and suggest splitting it into smaller issues before starting. Remove the two Large/Small bullets and the "mixes both signals" line. |
| `project-skills/issue-start.md` | Use the "Variant: no strategy" body in that file. |
| `trackers/github.md` | `{{STRATEGY_TRACKER_NOTES}}` is empty. |

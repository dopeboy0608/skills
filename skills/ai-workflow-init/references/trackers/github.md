# Tracker fragment: GitHub issues

The only tracker supported in this version. Rules in this file are the only place that describes how issues are read and managed.

## Slot values

- Marker value: `tracker=github`.
- `{{ISSUE_LOOKUP}}` (used by `project-skills/issue-start.md`): run `gh issue view <N> --json number,title,body,labels,state` and read title, body, and labels. Pass these to the strategy skill as issue number / title / body summary.
- `{{STRATEGY_TRACKER_NOTES}}`: the "GitHub issue mapping" block of the selected strategy fragment (empty if the strategy has none).
- `{{ARG_NOUN}}` → "an issue number". `{{ARG_HINT}}` → "issue number (e.g. 24)". `{{ITEM_INPUT}}` → "**Issue number**: if `$ARGUMENTS` has none, ask the user." `{{TRACKER_SECTION_NAME}}` → "GitHub issue management".
- `{{LABEL_STEP}}` → the bullet "`gh issue edit <N> --add-label in-progress` (ask first)".
- `{{BRANCH_PATTERN}}` → `<type>/<N>-<description>`. `{{BRANCH_TYPE_RULE}}` → "The type comes from the issue label (`bug`→`bug/`, `feature`→`feature/`, `chore`→`chore/`, `docs`→`docs/`); ask when there is no label."
- `{{HANDOFF_EXAMPLE}}` → `Issue #24: <title> — <body summary>`.
- Needs: the `gh` CLI installed and logged in (`gh auth status`). `ai-workflow-setup` checks this.

## Issue management rules (`{{TRACKER_RULES}}`)

Write this block into CLAUDE.md, translated.

---BEGIN---
## GitHub issue management

Register, edit, and change the state of issues with the `gh` CLI. Ask the user for confirmation every time before an externally visible action (create, edit, change state).

- **Create**: only when the user explicitly requests it; never auto-create when starting work.
- **Labels**: use `bug`, `feature`, `chore`, `docs`, `in-progress`. If the repository lacks them, announce it once and create them with `gh label create`.
- **State change**: add the `in-progress` label when the user says to start work on issue #N. Always ask before closing an issue.
- **Branch convention**: `type/issue-number-description`, with type one of `feature/`, `bug/`, `chore/`, `docs/` (for example `feature/12-description`). Recognize the issue number of the current work from the branch name; ask in the conversation if it cannot be recognized.
- **PR link**: a PR with a related issue automatically gets `Closes #N` in its description.
- **Direct push without a PR**: do not put closing keywords (`Closes #N`) in commit messages. After the work is done, ask "Close issue #N?" and close it with `gh issue close`.
- **Branch deletion**: never delete branches (local/remote) automatically, even after a PR merge. Delete only on the user's explicit request.
{{STRATEGY_TRACKER_NOTES}}
---END---

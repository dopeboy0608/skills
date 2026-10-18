# Tracker fragment: none (local documents only)

No issue tracker. Work items are plain requests; large tasks are tracked in the strategy's own documents. Nothing in the generated files may mention `gh`, issue numbers, labels, or `Closes #N`.

## Slot values

- Marker value: `tracker=none`.
- `{{ARG_NOUN}}` → "a short task description". `{{ARG_HINT}}` → "task description (e.g. add todo filter)".
- `{{ITEM_INPUT}}` → "**Task**: use `$ARGUMENTS`; if empty, ask the user what the task is and, for a large task, for a short slug."
- `{{ISSUE_LOOKUP}}` → "there is no tracker to read. Summarize the request in a title and 2–5 lines of requirements, show it to the user, and use that summary as the task from here on."
- `{{TRACKER_SECTION_NAME}}` → "Work tracking".
- `{{LABEL_STEP}}` → removed (no label step).
- `{{BRANCH_PATTERN}}` → `<type>/<slug>`. `{{BRANCH_TYPE_RULE}}` → "Choose the type from the nature of the request (`bug/`, `feature/`, `chore/`, `docs/`) and the slug from the title; confirm both with the user."
- `{{HANDOFF_EXAMPLE}}` → `<title> — <requirements summary>`.
- `{{STRATEGY_TRACKER_NOTES}}` → empty.
- Needs: nothing. `ai-workflow-setup` skips the `gh` check, the label check, and nothing else changes.

## Rules (`{{TRACKER_RULES}}`)

Write this block into CLAUDE.md, translated, in the place of the issue management section.

---BEGIN---
## Work tracking

There is no issue tracker in this project. Requests come from the conversation, and large tasks are recorded in the documents of the selected large-task workflow.

- **Branch convention**: `type/description`, with type one of `feature/`, `bug/`, `chore/`, `docs/` (for example `feature/todo-filter`). There is no issue number to recognize; ask in the conversation if the current work is unclear.
- **Commits**: write what and why in the message; there is no ticket key to include unless the team's convention says otherwise.
- **Branch deletion**: never delete branches (local/remote) automatically. Delete only on the user's explicit request.
- Do not create issues, labels, or `Closes` keywords, and do not run `gh issue` commands.
---END---

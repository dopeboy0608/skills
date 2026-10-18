# Preset fragment: speckit

Target stack: any, recommended first for backend-only projects. Artifacts and rules for this strategy live only in this file. Spec Kit is an external CLI (`specify`) that installs slash commands into the project; it is not part of the `dopeboy0608-skills` plugin.

## Slot values

- `{{STRATEGY_SKILL}}` → `speckit.specify`. The full flow is `speckit.specify` → `speckit.plan` → `speckit.tasks` → `speckit.implement`; the user starts with `speckit.specify`.
- `{{STRATEGY_INVOKE_NOTE}}` → empty (the commands are installed in the project, no plugin prefix).
- `{{STRATEGY_TRACKER_NOTES}}` → empty.
- Marker value: `strategy=speckit`.
- Requires (for the summary): the Spec Kit CLI and its project files. Without `specify init --here --integration claude` the `/speckit.*` commands do not exist and the large-task path does not work. `ai-workflow-setup` checks this.

## Workflow rules (`{{STRATEGY_RULES}}`)

Write this block into CLAUDE.md, translated, directly after the "Starting work on an issue" section.

---BEGIN---
## Large-task workflow: speckit

- **Commands**: the user runs `/speckit.specify <feature description>` and then continues with `/speckit.plan`, `/speckit.tasks`, `/speckit.implement`, as Spec Kit defines them. `issue-start` hands over a paste-ready `/speckit.specify` command built from the issue. Do not imitate these commands in this conversation.
- **Artifacts**: spec, plan, and task list live under `specs/<NNN-slug>/` and project principles under `.specify/` (for example `.specify/memory/constitution.md`). These are the source of truth for the large task; do not duplicate them in `docs/`.
- **Issue link**: write the issue number in the feature description and in the spec header so the work can be traced back. Do not turn the task list into separate issues unless the user asks.
- **Branch**: one branch per story. Spec Kit may create its own numbered branch; if it does, keep the issue number in the name when the user agrees, and do not create a second branch for the same story.
- **Commits and PR**: commit only on the user's request, after the user has checked the result of a `/speckit.implement` run. A PR for the story carries `Closes #N` for the story issue only.
- **Principles**: if `.specify/memory/constitution.md` exists, read it before planning and keep it consistent with this file; on a conflict, stop and ask the user which one wins.
- **Requires**: the Spec Kit CLI and `specify init --here --integration claude` run in this project.
---END---

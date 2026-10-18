# Preset fragment: feature-strategy

Target stack: frontend / full-stack. Artifacts and sub-task rules for this strategy live only in this file.

## Slot values

- `{{STRATEGY_SKILL}}` → `feature-strategy`.
- `{{STRATEGY_INVOKE_NOTE}}` → "With a plugin install the command is `/dopeboy0608-skills:feature-strategy`."
- Marker value: `strategy=feature-strategy`.
- Requires (for the summary): the `feature-strategy` skill (plugin or `.claude/skills/feature-strategy`). Without it the large-task path does not work. `ai-workflow-setup` checks this.

## Workflow rules (`{{STRATEGY_RULES}}`)

Write this block into CLAUDE.md, translated, directly after the "Starting work on an issue" section.

---BEGIN---
## Large-task workflow: feature-strategy

- **Skill**: `feature-strategy` runs the whole large-task procedure (story requirements → sub-task roadmap → one sub-task at a time with a human check before every commit). The user runs it; `issue-start` hands over a paste-ready command with the issue number, title, and a body summary.
- **Feature document**: `docs/feature/<issue number>-<slug>.md` (no `#` in the file name). It holds the roadmap, decision log, and progress log. If the tracker is not GitHub issues, follow the key format the skill specifies.
- **Sub-tasks**: created as GitHub **sub-issues** of the story issue (not as a checklist in the story body). The feature document is not the task list; it keeps the roadmap, decisions, and progress.
- **Issue creation approval**: creating issues is normally "only on the user's explicit request". The approval step of `feature-strategy` Phase B (the user confirms the roadmap and the drafts of sub-tasks 01–02) counts as that explicit request. Create sub-issues only after that approval.
- **Branch**: one branch per **story**, named `type/story-issue-number-description` (for example `feature/12-description`). Do not create a branch per sub-task.
- **Commits**: put the **sub-task issue number** in every sub-task commit message (follow the team's commit convention otherwise).
- **Draft PR**: after the first sub-task commit, ask before opening a Draft PR (it is visible to others). Put `Closes #N` **only for the story issue** in the PR description; never close sub-issues with it.
- **Checkpoints**: stop before every commit and wait for the user's verification, as the skill specifies.
- **Requires**: the `feature-strategy` skill from `dopeboy0608-skills` (installed as a plugin or as a project skill under `.claude/skills/`).
---END---

## GitHub issue mapping (inserted into the tracker rules)

Used by `trackers/github.md` at `{{STRATEGY_TRACKER_NOTES}}`:

---BEGIN---
- **Sub-tasks and links**: when a strategy splits a story into sub-tasks, create them as sub-issues linked under the story issue. Check what your `gh` version supports; if there is no command for linking sub-issues, use `gh api` with the sub-issues REST endpoint.
---END---

# Preset fragment: feature-strategy

Target stack: frontend / full-stack. Artifacts and sub-task rules for this strategy live only in this file.

## Slot values

- `{{STRATEGY_SKILL}}` → `feature-strategy`.
- `{{STRATEGY_PRECHECK}}` → empty.
- `{{STRATEGY_INVOKE_NOTE}}` → "With a plugin install the command is `/dopeboy0608-skills:feature-strategy`."
- Marker value: `strategy=feature-strategy`.
- Requires (for the summary): the `feature-strategy` skill (plugin or `.claude/skills/feature-strategy`). Without it the large-task path does not work. `ai-workflow-setup` checks this.

## Workflow rules (`{{STRATEGY_RULES}}`)

Write this block into CLAUDE.md, translated, directly after the "Starting work on an issue" section. The six bullets from "Feature document" to "Draft PR" depend on the tracker: write the selected tracker's version from "Tracker variants of the rules" below and never mix them.

---BEGIN---
## Large-task workflow: feature-strategy

- **Skill**: `feature-strategy` runs the whole large-task procedure (story requirements → sub-task roadmap → one sub-task at a time with a human check before every commit). The user runs it; `issue-start` hands over a paste-ready command with the issue number, title, and a body summary.
- **Feature document**: the story doc is `docs/feature/<issue number>-<slug>/<issue number>-<slug>.md` (no `#` in file names). It holds the roadmap, decision log, findings, and progress log. Each sub-task body is its own file `docs/feature/<issue number>-<slug>/sub-tasks/NN. <title>.md` (in file names, replace `>` with `-`). Older single-file docs are still read, not migrated.
- **Sub-tasks**: written as local files first. After that, ask **every time** whether to create them as GitHub **sub-issues** of the story issue (not as a checklist in the story body); the default is no. Without sub-issues, refer to sub-tasks by roadmap numbers (`01`, `02`, …). The feature document is not the task list; it keeps the roadmap, decisions, and progress.
- **Issue creation approval**: never create issues, sub-issues, or labels, or edit an issue body, without the user's explicit approval each time. Approving the `feature-strategy` roadmap and the drafts of sub-tasks 01–02 is **not** that approval; the skill asks separately after the local docs are written. Do not create labels yourself: show the `gh label create` command for the user to run.
- **Branch**: one branch per **story**, named `type/story-issue-number-description` (for example `feature/12-description`). Do not create a branch per sub-task.
- **Commits**: put the **sub-task key** in every sub-task commit message: `#<number>` if its sub-issue was created, otherwise the roadmap number (for example `[02]`). Follow the team's commit convention otherwise.
- **Draft PR**: after the first sub-task commit, ask before opening a Draft PR (it is visible to others). Put `Closes #N` **only for the story issue** in the PR description; never close sub-issues with it.
- **Checkpoints**: stop before every commit and wait for the user's verification, as the skill specifies.
- **Requires**: the `feature-strategy` skill from `dopeboy0608-skills` (installed as a plugin or as a project skill under `.claude/skills/`).
---END---

## Tracker variants of the rules

Use the bullets of the selected tracker in place of the first six bullets of the block above (the "Skill" bullet and everything from "Checkpoints" on stay as they are).

### tracker = github

The six bullets exactly as written above (Feature document through Draft PR).

### tracker = none

- **Feature document**: `docs/feature/<slug>/<slug>.md` (story doc) plus `docs/feature/<slug>/sub-tasks/NN. <title>.md` (one file per sub-task; in file names, replace `>` with `-`) are the **single source of truth**: the story requirements, the roadmap, each sub-task body, the decision log, and the progress log all live there. The skill's "no tracker" mode applies.
- **Sub-tasks**: identified by roadmap numbers `01`, `02`, … (the files under `sub-tasks/`). Never create issues; do not run `gh issue` commands.
- **Branch**: one branch per **story**, named `type/slug` (for example `feature/todo-filter`). Do not create a branch per sub-task.
- **Commits**: put the **roadmap number** (for example `[02]`) in every sub-task commit message.
- **PR**: after the first sub-task commit, ask before opening a Draft PR (it is visible to others). Do not write closing keywords.

### tracker = custom

- **Feature document**: story doc `docs/feature/<ticket key>-<slug>/<ticket key>-<slug>.md` plus one file per sub-task under `sub-tasks/NN. <title>.md`. It holds the roadmap, decision log, findings, and progress log.
- **Sub-tasks**: written as local files first. After that, ask **every time** whether to create them in the tracker with its own tools, as the skill's "Jira and other trackers" mapping describes; the default is no. If created, the sub-task key is whatever the tracker returns; otherwise use the roadmap numbers.
- **Ticket creation approval**: never create or edit tickets without the user's explicit approval each time. Approving the roadmap is **not** that approval; the skill asks separately after the local docs are written.
- **Branch**: one branch per **story**, named `type/KEY-description`. Do not create a branch per sub-task.
- **Commits**: put the **sub-task key** in every sub-task commit message (the tracker key if created, otherwise the roadmap number).
- **PR**: ask before opening a Draft PR; link tickets by the team's convention, not by invented closing keywords.

## GitHub issue mapping (inserted into the tracker rules)

Used by `trackers/github.md` at `{{STRATEGY_TRACKER_NOTES}}`:

---BEGIN---
- **Sub-tasks and links**: only after the user approves creating tracker sub-tasks (the strategy asks every time; the default is no), create them as sub-issues linked under the story issue. Check what your `gh` version supports; if there is no command for linking sub-issues, use `gh api` with the sub-issues REST endpoint. Never create labels yourself; show the `gh label create` command for the user to run.
---END---

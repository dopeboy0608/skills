# Development guide

How to change and test the skills in this repository. The repository is the single source of truth for `ai-workflow-init` and `ai-workflow-setup`; no external template repository is used. Korean version: [DEVELOPMENT.ko.md](./DEVELOPMENT.ko.md).

## Layout

- `skills/<name>/SKILL.md` and `SKILL.ko.md` — every skill ships an English and a Korean file; `SKILL.md` is the one loaded at run time.
- `skills/ai-workflow-init/references/` — templates and fragments (`core/`, `strategies/`, `trackers/`, `project-skills/`). Only the fragment of a **selected** option may influence the generated files.
- `skills/ai-workflow-setup/references/` — scaffold, quality tools, CI, and per-strategy hooks.
- `.claude-plugin/plugin.json` — plugin manifest and version.

## Test with the sandbox pack

The local test pack is **kept as the maintenance test strategy**: it lets you run the skills against a blank project without installing the plugin. `_sandbox-pack/` itself is git-ignored (it is generated); the script that builds it is versioned.

```bash
./scripts/sync-sandbox.sh                      # rebuild _sandbox-pack/ from skills/
mkdir ~/tmp/aiw-test && cd ~/tmp/aiw-test && git init
cp -R <repo>/_sandbox-pack/.claude .           # an EMPTY directory each time
# open a NEW Claude Code session here, then run /ai-workflow-init and /ai-workflow-setup
```

Always re-run the sync script after editing anything under `skills/`, and use a fresh directory for every scenario (re-runs are a scenario of their own).

To check the plugin install path instead, use a local marketplace or `claude --plugin-dir <repo>` and confirm the namespaced commands (`/dopeboy0608-skills:ai-workflow-init`).

## Scenario checklist (copy into the PR description)

Frontend is the supported focus; backend and full-stack are best effort and not a merge condition.

- [ ] Strategy: `feature-strategy` / `speckit` / none is not offered on a frontend-only stack
- [ ] Tracker: GitHub / none / other — no trace of the unselected ones in `CLAUDE.md`, `issue-start`, or setup output
- [ ] Document language: English and Korean (the headings and `issue-start` follow the choice)
- [ ] Re-run `/ai-workflow-init` in an initialized project (no repeated interview, nothing overwritten)
- [ ] Decline at the preview and at each setup approval (nothing is written or run)
- [ ] `/ai-workflow-setup` order: generator → install → quality tools → CI → directories → tools
- [ ] No leftover `{{slot}}` in any generated file
- [ ] `SKILL.md` and `SKILL.ko.md` agree; the sandbox pack was re-synced before testing
- [ ] `plugin.json` version raised according to the rules below

## Structure validation

`./scripts/validate-skills.sh` checks `plugin.json`, that every listed skill has `SKILL.md` and `SKILL.ko.md` with a matching frontmatter `name` and a `description`, that no skill folder is missing from the manifest, that the marker version in `ai-workflow-init` equals the plugin version, and that `_sandbox-pack` is not tracked. CI (`.github/workflows/validate.yml`) runs it on every pull request; the PR template carries the scenario checklist.

## Version rules

- Changing an existing skill (content under `SKILL.md` or `references/`) → **patch**.
- Adding a new skill → **minor**. Changes during the first publishing period of a new skill count as part of adding it.
- Breaking changes → **major**, only when the maintainer asks for it in the PR.
- Docs, scripts, or CI only → no version change.

The generated `CLAUDE.md` marker (`<!-- ai-workflow: version=… -->`) carries the skill version that produced it; keep it equal to `plugin.json` when skill content changes.

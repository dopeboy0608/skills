# issue-start template (generated into the project)

Create this as `.claude/skills/issue-start/SKILL.md` in the project. Replace the slots, translate the body into the user's language (keep the frontmatter keys, and keep `name` as `issue-start`), and show the result in the approval list.

Slots: `{{STRATEGY_SKILL}}` — substituted in exactly **one** place (step 6). `{{ISSUE_LOOKUP}}` — from the tracker fragment (step 2). `{{DEFAULT_BRANCH_NOTE}}` — name the repository's actual default branch (check `git symbolic-ref --short HEAD` or `git branch`), for example "this repository uses `master`".

Do not write the routing criteria into this file: `docs/ARCHITECTURE.md` ("Task routing criteria") is the single source.

---BEGIN---
```markdown
---
name: issue-start
description: Standard starting point for issue work. Takes an issue number, reads it, recommends "small task (implement directly)" or "large task (strategy skill)" with reasons, and branches after the user confirms. Triggered by "start issue #N", "pick up the issue", or an explicit /issue-start call.
argument-hint: issue number (e.g. 24)
---

# issue-start

The standard entry point once an issue is registered. The routing criteria live in `docs/ARCHITECTURE.md` ("Task routing criteria"); this skill only applies them. When the criteria change, edit ARCHITECTURE.md first.

## Procedure

1. **Issue number**: if `$ARGUMENTS` has none, ask the user.
2. **Read the issue**: {{ISSUE_LOOKUP}}
3. **Judge**: apply the signals in "Task routing criteria" to the issue and pick one to recommend.
   - **A. Small task** (implement directly)
   - **B. Large task** (strategy skill)
   - If the issue mixes both, decide by which signal is closer to the core risk and say why briefly.
4. **Recommend and confirm**: explain the reason in 1–2 sentences, give your recommended answer, and have the user choose A or B. If the user chooses differently, follow it; the recommendation is only a hint.
5. **Common preparation** (both paths), following "GitHub issue management" in CLAUDE.md:
   - `gh issue edit <N> --add-label in-progress` (ask first)
   - Create the branch from the repository's default branch ({{DEFAULT_BRANCH_NOTE}}): `git checkout <default> && git pull origin <default> --ff-only` (skip the pull when there is no `origin` remote) `&& git checkout -b <type>/<N>-<description>`. The type comes from the issue label (`bug`→`bug/`, `feature`→`feature/`, `chore`→`chore/`, `docs`→`docs/`).
   - **Path A:** create the branch now. **Path B:** do not create a branch here; the single story branch is created when the strategy skill reaches implementation, following the strategy rules in CLAUDE.md.
6. **Branch**:
   - **A**: no skill call; start implementing in this conversation from the issue content. Afterwards run the format/lint/test commands from the "Commands" section of CLAUDE.md. Commit/PR/merge only on the user's explicit request.
   - **B**: invoke the `{{STRATEGY_SKILL}}` skill with the Skill tool. Pass the issue number, title, and a body summary (for example `Issue #24: <title> — <body summary>`). Tell it the label/branch work is already done. If the skill is not found, tell the user to run `ai-workflow-setup` (it checks the plugin) and stop.

## What this skill does not do

- It does not commit, open PRs, or merge on its own; it waits for the user's request.
- It does not list the routing criteria itself; ARCHITECTURE.md is the single source.
```
---END---

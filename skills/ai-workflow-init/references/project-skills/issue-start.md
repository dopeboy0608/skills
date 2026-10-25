# issue-start template (generated into the project)

Create this as `.claude/skills/issue-start/SKILL.md` in the project. Replace the slots, translate the body into the user's language (keep the frontmatter keys, and keep `name` as `issue-start`), and show the result in the approval list.

Tracker slots (`{{ARG_NOUN}}`, `{{ARG_HINT}}`, `{{ITEM_INPUT}}`, `{{ISSUE_LOOKUP}}`, `{{TRACKER_SECTION_NAME}}`, `{{LABEL_STEP}}` (a whole bullet line, or removed), `{{BRANCH_PATTERN}}`, `{{BRANCH_TYPE_RULE}}`, `{{HANDOFF_EXAMPLE}}`) all come from the selected tracker fragment ("Slot values"). Slots: `{{STRATEGY_SKILL}}` — substituted in exactly **one** place (step 6). `{{STRATEGY_INVOKE_NOTE}}` — from the strategy fragment (step 6; drop the sentence when empty). `{{STRATEGY_PRECHECK}}` — from the strategy fragment (a whole bullet under step 4, or removed when empty). `{{ISSUE_LOOKUP}}` — from the tracker fragment (step 2). `{{DEFAULT_BRANCH_NOTE}}` — name the repository's actual default branch (check `git symbolic-ref --short HEAD` or `git branch`), for example "this repository uses `master`".

Do not write the routing criteria into this file: `docs/ARCHITECTURE.md` ("Task routing criteria") is the single source.

---BEGIN---
```markdown
---
name: issue-start
description: Standard starting point for issue work. Takes {{ARG_NOUN}}, reads it, recommends "small task (implement directly)" or "large task (strategy skill)" with reasons, and branches after the user confirms. Triggered by "start issue #N", "pick up the issue", or an explicit /issue-start call.
argument-hint: {{ARG_HINT}}
---

# issue-start

The standard entry point once an issue is registered. The routing criteria live in `docs/ARCHITECTURE.md` ("Task routing criteria"); this skill only applies them. When the criteria change, edit ARCHITECTURE.md first.

## Procedure

1. **Input**: {{ITEM_INPUT}}
2. **Read the issue**: {{ISSUE_LOOKUP}}
3. **Judge**: apply the signals in "Task routing criteria" to the issue and pick one to recommend.
   - **A. Small task** (implement directly)
   - **B. Large task** (strategy skill)
   - If the issue mixes both, decide by which signal is closer to the core risk and say why briefly.
4. **Recommend and confirm**: explain the reason in 1–2 sentences, give your recommended answer, and have the user choose A or B. If the user chooses differently, follow it; the recommendation is only a hint.
{{STRATEGY_PRECHECK}}
5. **Common preparation** (both paths), following "{{TRACKER_SECTION_NAME}}" in CLAUDE.md:
{{LABEL_STEP}}
   - Create the branch from the repository's default branch ({{DEFAULT_BRANCH_NOTE}}). **Base check first**: if the current branch is ahead of the default branch with workflow setup that the default branch lacks (for example `CLAUDE.md` or `package.json` exists only on the current branch, or `git log <default>..HEAD` shows setup commits), branching from the default branch would drop that work. Say so and ask "branch from `<default>` or from the current branch `<current>`?" with the current branch recommended in that case; never silently choose. Commands for the default-branch case: `git checkout <default> && git pull origin <default> --ff-only` (skip the pull when there is no `origin` remote) `&& git checkout -b {{BRANCH_PATTERN}}`. {{BRANCH_TYPE_RULE}}
   - **Path A:** create the branch now. **Path B:** do not create a branch here; the single story branch is created when the strategy skill reaches implementation, following the strategy rules in CLAUDE.md.
6. **Branch**:
   - **A**: no skill call; start implementing in this conversation from the issue content. Afterwards run the format/lint/test commands from the "Commands" section of CLAUDE.md. Commit/PR/merge only on the user's explicit request.
   - **B**: the strategy skill is run by the user, so do not call it with the Skill tool and do not imitate its procedure. Hand off instead: finish the common preparation the user approved, then print one paste-ready command for the user to run, with the identifier, title, a body summary, and any facts already known from the issue. Example: `/{{STRATEGY_SKILL}} {{HANDOFF_EXAMPLE}}`. {{STRATEGY_INVOKE_NOTE}} Tell the user that the label/branch work is already done. If the user says the command is not found, tell them to run `ai-workflow-setup` (it checks what the strategy needs) and stop.

## What this skill does not do

- It does not commit, open PRs, or merge on its own; it waits for the user's request.
- It does not list the routing criteria itself; ARCHITECTURE.md is the single source.
```
---END---

## Variant: no strategy (`strategy=none`)

Use this body instead of the one above. It has no large-task path, no `{{STRATEGY_SKILL}}`, and no routing step. Keep the same frontmatter keys; change `description` to: "Standard starting point for issue work. Takes {{ARG_NOUN}}, reads it, prepares the label and branch after the user confirms, and starts implementing. Triggered by "start issue #N", "pick up the issue", or an explicit /issue-start call."

---BEGIN---
```markdown
# issue-start

The standard entry point once an issue is registered. Every issue is implemented directly in this conversation.

## Procedure

1. **Input**: {{ITEM_INPUT}}
2. **Read the issue**: {{ISSUE_LOOKUP}}
3. **Size check**: if the issue looks too big or its requirements are ambiguous (see "Task routing criteria" in `docs/ARCHITECTURE.md`), say so in 1–2 sentences and suggest splitting it into smaller issues first. If the user wants to go ahead anyway, follow it.
4. **Preparation**, following "{{TRACKER_SECTION_NAME}}" in CLAUDE.md:
{{LABEL_STEP}}
   - Create the branch from the repository's default branch ({{DEFAULT_BRANCH_NOTE}}). **Base check first**: if the current branch is ahead of the default branch with workflow setup that the default branch lacks (for example `CLAUDE.md` or `package.json` exists only on the current branch, or `git log <default>..HEAD` shows setup commits), branching from the default branch would drop that work. Say so and ask "branch from `<default>` or from the current branch `<current>`?" with the current branch recommended in that case; never silently choose. Commands for the default-branch case: `git checkout <default> && git pull origin <default> --ff-only` (skip the pull when there is no `origin` remote) `&& git checkout -b {{BRANCH_PATTERN}}`. {{BRANCH_TYPE_RULE}}
5. **Implement** from the issue content; do not write a separate spec document. Afterwards run the format/lint/test commands from the "Commands" section of CLAUDE.md. Commit/PR/merge only on the user's explicit request.

## What this skill does not do

- It does not commit, open PRs, or merge on its own; it waits for the user's request.
```
---END---

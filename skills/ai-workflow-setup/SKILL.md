---
name: ai-workflow-setup
description: Set up the development environment for a project initialized with ai-workflow-init — detect the stack, run the scaffolding CLI after approval, add missing frontend/backend directories, and check the tools the chosen workflow needs (gh, dopeboy0608-skills plugin). Safe to re-run and can run standalone in a project that already has the rule documents. Recommended for first-time adopters of an AI workflow. Use only when invoked explicitly via /ai-workflow-setup.
disable-model-invocation: true
---

# AI Workflow Setup

Turn the rule documents into a working development environment. Run it after `ai-workflow-init`, or on its own in a project that already has `CLAUDE.md` with the `ai-workflow:` marker. Safe to re-run: existing directories and files are never touched.

> **Explicit invocation only.** Run only when the user calls `/ai-workflow-setup`.
>
> **Recommended for** people adopting an AI workflow for the first time.

Scaffold references are in this skill's `references/scaffold/` (`fe-scaffold.md`, `be-scaffold.md`). Never clone, fetch, or link an external template repository.

## Steps

Ask for confirmation between steps. Write all user-facing text in the language of the project's `CLAUDE.md`. Start with a one-line banner that lists the steps (read choices → CLI → directories → tools → report), numbered "Step n/5" as you go, so prompts are not mistaken for errors. Do not narrate internal steps such as reading references.

### 0. Read the project's choices
Read `CLAUDE.md`. The marker `<!-- ai-workflow: version=… strategy=… tracker=… stack=… -->` gives the strategy, tracker, and stack. If the file or marker is missing, tell the user to run `/ai-workflow-init` first (or ask for the three values and continue if they insist). Do not edit `CLAUDE.md` except in step 4 if the user asks.

### 1. Judge the stack
Use `stack=` from the marker; if absent or unclear, ask "frontend, backend, or full-stack?".

### 2. Scaffolding CLI (approval required)
- If the project already has a manifest (`package.json`, `pyproject.toml`, `go.mod`, ...) or source folders, show what exists and skip the CLI.
- Otherwise, propose the CLI that fits the tech stack in `CLAUDE.md` (for example `npm create vite@latest`, `create-next-app`, `nest new`), show the exact command, and ask "Run it now?". Run it only after a yes. A user who declines, or a stack with no CLI, simply skips this step.
- Create directories **only after** this step; creating them first conflicts with what the CLI generates. If the CLI refuses a non-empty directory (because of `CLAUDE.md`, `docs/`, `.claude/`), propose a temp directory and moving the result in, or let the user decide; never delete the existing files.

### 3. Add missing directories
- Show what already exists (including what the CLI created).
- Frontend → `references/scaffold/fe-scaffold.md`; backend → `be-scaffold.md`; full-stack → show both and ask which layout goes where (for example `frontend/` and `backend/`, or the repository's existing split).
- Ask "Add this structure on top?". If yes, create **only the directories that do not exist yet**, each with a `.gitkeep`. Never overwrite or move existing files and never create code files. Create the optional domain-only subfolders only when needed, as the reference says. Declining or "another structure already exists" skips the step.

### 4. External dependencies (only what the choices need)
- **`dopeboy0608-skills` plugin** (provides `feature-strategy`, `code-organizer`, `fowler-refactor`): there is no reliable way to check it programmatically, so ask. If missing, give the install steps (`/plugin marketplace add dopeboy0608/skills`, `/plugin install dopeboy0608-skills`, `/reload-plugins`) but do not run them. Without it, `issue-start` cannot call `feature-strategy` and the `/code-organizer` rules in `CLAUDE.md` cannot apply.
- **Strategy `feature-strategy`**: no extra installation or setup.
- **Tracker `github`** (only then): check `command -v gh` and `gh auth status`; if missing or not logged in, tell the user how to install/log in and let them do it. Optionally check that `git remote` points to GitHub.
- An interview-style plugin such as `grill-me` is optional; mention it in one line, never required.

### 5. Report
Short summary: stack judged, CLI run/skipped, directories added/skipped, dependency status, and the next action (for example: "Start work with `/issue-start <issue number>`; large tasks will call `feature-strategy`").

## What this skill does not do

- Run anything without approval, install plugins or tools on the user's behalf, or overwrite existing files.
- Commit, push, or open PRs.
- Change the strategy or tracker (re-run `/ai-workflow-init` after discussing it with the user).

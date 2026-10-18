---
name: ai-workflow-setup
description: Set up the development environment for a project initialized with ai-workflow-init — detects frontend/backend/full-stack, runs the project scaffolding CLI (e.g. Vite, Next.js) after approval, adds missing directories, syncs CLAUDE.md commands and tech stack, and checks required tools (gh CLI, dopeboy0608-skills plugin). Safe to re-run and can run standalone. Recommended for first-time adopters of an AI workflow. Use only when invoked explicitly via /ai-workflow-setup.
disable-model-invocation: true
---

# AI Workflow Setup

Turn the rule documents into a working development environment. Run it after `ai-workflow-init`, or on its own in a project that already has `CLAUDE.md` with the `ai-workflow:` marker. Safe to re-run: existing directories and files are never touched.

> **Explicit invocation only.** Run only when the user calls `/ai-workflow-setup`.
>
> **Recommended for** people adopting an AI workflow for the first time.

Scaffold references are in this skill's `references/scaffold/` (`fe-scaffold.md`, `be-scaffold.md`), quality tool options in `references/quality-tools.md`, CI template in `references/ci-workflow.md`; per-strategy setup hooks are in `references/strategy-hooks.md`. Never clone, fetch, or link an external template repository.

## Steps

Ask for confirmation between steps. Write all user-facing text in the language of the project's `CLAUDE.md`. Start with a one-line banner that lists the steps (read choices → CLI → dependencies → quality tools → CI → directories → tools and strategy hook → report), numbered "Step n/5" as you go, so prompts are not mistaken for errors. Do not narrate internal steps such as reading references.

**Prompt format** (use it for every approval question in every step, so the steps look the same each time; translate the labels):

```
### Step 2/5 · Install a development environment
What this does in one sentence, and what it does NOT do.

1. Rsbuild + React (pnpm)  ← recommended
2. Vite + React (npm)
3. Skip (I will set it up myself)

Command: `pnpm create rsbuild@latest`
Creates: package.json, rsbuild config, src/ entry files
> Run option 1 now? (yes / pick another / skip)
```

Always show: step title, one-sentence purpose, the choices (or the single proposed action), the exact command, what will be created or changed, and a closing one-line question. Mark the recommended choice with `← recommended`. Keep each prompt under ~12 lines.

### 0. Read the project's choices
Read `CLAUDE.md`. The marker `<!-- ai-workflow: version=… strategy=… tracker=… stack=… -->` gives the strategy, tracker, and stack. If the file or marker is missing, tell the user to run `/ai-workflow-init` first (or ask for the three values and continue if they insist). Do not edit `CLAUDE.md` or `docs/` except in step 3b.

### 1. Judge the stack
Use `stack=` from the marker; if absent or unclear, ask "frontend, backend, or full-stack?".

### 2. Development environment install via a project generator CLI (approval required)
This step **installs a development environment**: a generator CLI creates the manifest (`package.json`), bundler/framework config, source entry files, and may install dependencies. It is different from step 3, which only creates empty folders. Say this in one sentence when you introduce the step, and title the prompt "Install a development environment (project generator)", not "scaffolding".
- If the project already has a manifest (`package.json`, `pyproject.toml`, `go.mod`, ...) or source folders, show what exists and skip the CLI.
- Otherwise, offer the options that fit the tech stack in `CLAUDE.md` as a short numbered list, recommend one, and always include "skip (I will set it up myself)". For a frontend or the frontend part of full-stack:
  1. Vite (React/TS template): `npm create vite@latest` (the project's package manager may differ)
  2. Rsbuild with **pnpm**: `pnpm create rsbuild@latest`
  3. Next.js: `npx create-next-app@latest`
  
  For a backend, offer the framework's own generator (for example `nest new`) or skip. Prefer the package manager already named in `CLAUDE.md`; check that `pnpm` exists (`command -v pnpm`) before offering option 2 and say how to install it if missing, without installing it.
- After the user picks one, show the exact command, what it will create, and ask "Run it now?". Run it only after a yes.
- **Merging a temp-directory result** (when the target is not empty): copy only files that do not exist yet. Never overwrite. Special cases: `.gitignore` is merged by **adding the generator's missing lines** to the existing file (show the added lines first); an existing `README.md` or `AGENTS.md` is kept and the generator's version is only mentioned. Leave the generator's sample code (`src/App.tsx`, entry files, styles) untouched and do not move it into the directory layout; just tell the user it exists. A user who declines, or a stack with no CLI, simply skips this step.
- Create directories **only after** this step; creating them first conflicts with what the CLI generates. If the CLI refuses a non-empty directory (because of `CLAUDE.md`, `docs/`, `.claude/`), propose a temp directory and moving the result in, or let the user decide; never delete the existing files.

### 2b. Install dependencies (separate approval)
Right after the generator, ask separately: "Install dependencies now (`<pm> install`)?" with the package manager from `CLAUDE.md` or the generator choice. Run it only after a yes. Expected result: a lockfile (`pnpm-lock.yaml`, `package-lock.json`, ...) appears and `node_modules/` fills; check that `node_modules` is git-ignored and tell the user to commit the lockfile. If any other tracked file changed (`package.json`, config), show the diff. If the user declines, say that dev/build commands will not work until they install.

### 2c. Formatter, linter and test tools (separate approvals)
Follow `references/quality-tools.md`. If the init interview already recorded a choice in `CLAUDE.md`, install that; otherwise recommend the stack's defaults. These tools are what lets the rules in `CLAUDE.md` (format/lint after coding, run tests, TDD) actually run. Declining is fine: say which rule cannot be followed yet.

### 2d. CI workflow (approval required)
Follow `references/ci-workflow.md`: one GitHub Actions file that runs the scripts that exist (lint, typecheck, test, build) on pull requests. Only for the GitHub tracker; skip if the project has no scripts yet.

### 3. Add missing directories (folders only, no installation)
Say plainly that this step only creates empty folders (each with a `.gitkeep`); it installs nothing and creates no code files.
- Show what already exists (including what the CLI created).
- Frontend → `references/scaffold/fe-scaffold.md`; backend → `be-scaffold.md`; full-stack → show both and ask which layout goes where (for example `frontend/` and `backend/`, or the repository's existing split).
- Ask "Add this structure on top?". If yes, create **only the directories that do not exist yet**, each with a `.gitkeep`. Never overwrite or move existing files and never create code files. Create the optional domain-only subfolders only when needed, as the reference says. Declining or "another structure already exists" skips the step.

### 3b. Sync the documents with what now exists
`ai-workflow-init` may have left "not decided yet" sentences. After steps 2–3, show the user a short before/after for these and write them only after approval; change nothing else in the documents:
- `CLAUDE.md` "Commands": real commands from `package.json` scripts (or the stack's equivalent), including the scripts added in step 2c; say plainly which of lint/format/test still do not exist instead of inventing them.
- `CLAUDE.md` "Tech stack" and "Directory structure", and the matching lines of `docs/ARCHITECTURE.md`: what the CLI and the scaffold actually produced.
- **Check `.gitignore`:** scaffolding CLIs may rewrite it. Confirm the `docs/history/*` lines from init are still there and re-add only the missing lines. Note that the CLI may also have created its own `README.md`; mention it and leave it as is.

### 4. External dependencies (only what the choices need)
- **`dopeboy0608-skills` plugin** (provides `code-organizer` and `fowler-refactor` for every project, and `feature-strategy` when selected): check first whether the skills are present locally (`.claude/skills/code-organizer`, `.claude/skills/fowler-refactor`, and `.claude/skills/feature-strategy` when selected, or the same under `~/.claude/skills/`); if they are, treat the requirement as met and do not mention the plugin. A plugin install cannot be checked programmatically, so only when the local folders are missing, ask. If missing, give the install steps (`/plugin marketplace add dopeboy0608/skills`, `/plugin install dopeboy0608-skills`, `/reload-plugins`) but do not run them. Without it the `/code-organizer` rules in `CLAUDE.md` cannot apply, and the `feature-strategy` large-task path (if selected) does not work.
- **Strategy hook**: run the section of `references/strategy-hooks.md` that matches the marker's `strategy=` (and no other). It covers `speckit` (CLI check, `specify init --here --integration claude` and a one-time `AGENTS.md` sync, each only after approval), a custom skill (guidance only, nothing is run), and `feature-strategy` / `none` (nothing extra).
- **Tracker `github`** (only then): check `command -v gh` and `gh auth status`; if missing or not logged in, tell the user how to install/log in and let them do it. Optionally check that `git remote` points to GitHub.
  - **Labels**: the workflow uses `bug`, `feature`, `chore`, `docs`, `in-progress`. With a GitHub remote and a logged-in `gh`, run `gh label list`, show which of the five are missing, and ask "Create the missing labels?". Create only the missing ones with `gh label create <name> --color <hex> --description "<text>"` after a yes; never edit or delete existing labels. Without a remote, skip and say so.
- An interview-style plugin such as `grill-me` is optional; mention it in one line, never required.

### 5. Report
Short summary: stack judged, CLI run/skipped, directories added/skipped, dependency status, and whether the selected strategy's requirement is met (say plainly if the large-task path will not work yet and why), and the next action (for example: "Start work with `/issue-start <issue number>`"). Mention only the selected strategy.

## What this skill does not do

- Run anything without approval, install plugins or tools on the user's behalf, or overwrite existing files.
- Commit, push, or open PRs.
- Change the strategy or tracker (re-run `/ai-workflow-init` after discussing it with the user).

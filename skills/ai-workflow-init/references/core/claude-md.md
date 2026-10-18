# CLAUDE.md template

Source for the generated `CLAUDE.md`. Fill every `{{SLOT}}` from the interview and the selected presets, then translate all prose into the user's language (see the language table in `SKILL.md`). Keep every instruction below the marker line. Remove this header, and drop any section whose slot is empty only if the section says so.

Slots: `{{PROJECT_PURPOSE}}`, `{{COMMANDS}}`, `{{DIR_STRUCTURE}}`, `{{TECH_STACK}}`, `{{STRATEGY_SKILL}}` (once, in the large-task bullet; absent when the strategy is `none`), `{{TRACKER_RULES}}` (from `trackers/<tracker>.md`), `{{STRATEGY_RULES}}` (from `strategies/<strategy>.md`, "Workflow rules" block; absent when the strategy is `none`, see `strategies/none.md` for the other edits), `{{MARKER}}` (the settings marker line).

---BEGIN---
# CLAUDE.md

{{MARKER}}

## Project purpose / current scope

{{PROJECT_PURPOSE}}

Do not implement features outside the current scope without discussing it first. Details of the scope live in `docs/ARCHITECTURE.md`.

## Commands

{{COMMANDS}}

## Rules after writing code

- After writing or changing code, run the formatter/linter and fix issues before committing. If a pre-commit hook (husky + lint-staged, etc.) exists, make sure it runs on the changed files.
- For **new code** (files/functions/components added in this task), finish by running `/code-organizer` (`dopeboy0608-skills`) to sort imports and the hook/state/effect layout inside components. Then, if it seems worthwhile, ask `/fowler-refactor` (same skill set) for structure improvements and review them; apply code changes only after the user approves. Neither skill changes behavior without a prior proposal, so they are safe on new code.
- Do **not** auto-apply `/code-organizer` to **existing code**; large diffs collide with collaborators. Do it only when the user explicitly asks. Same for `/fowler-refactor`: use it on existing code only when the user invokes it.
- Leave comments that explain WHY (hidden constraints, non-obvious behavior, trade-offs). Express WHAT through names and do not repeat it in comments. This rule overrides Claude Code's default "write no comments" behavior.

## Test harness criteria

Apply the following automatically, even without a request (see `docs/ARCHITECTURE.md`).

- Write the test first, then the implementation (TDD) for pure functions with clear inputs/outputs and no side effects. The target criteria are in "TDD criteria" of `docs/ARCHITECTURE.md`.
- When adding or changing external API calls, verify the success and error responses as tests (with MSW or similar on the frontend).
- When testing code that uses an SDK that needs network access or global scripts to load or initialize (maps, payments, editors, etc.), mock it instead of loading the real SDK. The strategy is defined in "External SDK mocking" of `docs/ARCHITECTURE.md`.
- After writing or changing code, run the tests and confirm they pass.
- Do not introduce E2E tests (Playwright, etc.) on your own; propose them first and apply only after the user agrees.

## Directory structure

{{DIR_STRUCTURE}}

## Tech stack

{{TECH_STACK}}

When extra libraries (TanStack Query, etc.) seem necessary, do not add them on your own: propose first and apply after the user agrees.

## Prohibited

- Do not hardcode API keys in code. Manage them with environment variables.
- Do not implement features outside the current scope without discussing it first.

{{TRACKER_RULES}}

## Starting work on an issue

Start work on an issue with the `issue-start` skill (`.claude/skills/issue-start/`), after the issue has been refined and registered. It reads the issue and recommends one of two paths; the user always makes the final choice.

- **Small task (implement directly)**: create the branch → implement → test/format/lint → (on request) commit/PR. The request or the ticket content is the spec; do not write a separate spec document.
- **Large task**: the user runs `/{{STRATEGY_SKILL}}` (explicit-invocation skill); `issue-start` prepares the issue and hands over a paste-ready command. The procedure and artifacts follow that skill.

The recommendation criteria are in "Task routing criteria" of `docs/ARCHITECTURE.md`. Both paths follow the issue and branch conventions above, and commit/PR only when the user explicitly asks (except where the strategy rules below say otherwise).

{{STRATEGY_RULES}}

## Daily work history log

Commit history alone does not explain why a change was made, so keep a per-day timeline in `docs/history/YYYY-MM-DD.md`. This directory is git-ignored (internal notes; track it in git instead if the repository is private).

- **Unit**: record once per completed user request (one task), not per commit.
- **When**: record automatically, without asking.
- **Format**:
  ```
  ## HH:MM — <title>
  - Reason: <why this work was done>
  - Changes: <what was changed and how>
  - Related issue: #N (if any)
  - Related commit: <hash> (if any)
  ```

## Troubleshooting log

Conversations or work that count as problem solving (debugging, root-cause analysis, technical decisions such as why an approach does not work) are recorded cumulatively in `docs/TROUBLE_SHOOTING.md`. Unlike the history log, this file is tracked by git (a public reference for anyone who hits the same problem).

- **Record**: finding a root cause ("why it fails") or choosing between alternatives. Not plain feature work.
- **When**: record automatically, without asking.
- **Format**:
  ```
  ## YYYY-MM-DD HH:MM — <problem/topic>
  - Symptom: <what went wrong>
  - Cause: <root cause or review result>
  - Resolution/conclusion: <how it was fixed or what was decided>
  - Related issue/PR: <if any>
  ```
---END---

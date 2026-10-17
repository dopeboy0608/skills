---
name: ai-workflow-init
description: Bootstrap an AI coding workflow in a blank (or existing) project — through a short interview, generate CLAUDE.md rules, docs/ARCHITECTURE.md, docs/TROUBLE_SHOOTING.md and an issue-start skill (small task vs. large task routing, GitHub issues). Never overwrites existing files and shows a preview before writing. Recommended for first-time adopters of an AI workflow or anyone who wants a minimal setup with little configuration. Run /ai-workflow-setup afterwards. Use only when invoked explicitly via /ai-workflow-init.
disable-model-invocation: true
---

# AI Workflow Init

Create the rule documents that let an AI agent work in a project the same way every time, starting from a blank directory. The skill interviews the user, shows the list of files it will write, and writes them only after approval. It never overwrites an existing file.

> **Recommended for** people adopting an AI workflow for the first time, and anyone who wants a minimal setup without complicated configuration.
>
> **Explicit invocation only.** Run only when the user calls `/ai-workflow-init`.
>
> **Scope of this version.** Large-task workflow: `feature-strategy` only. Issue tracker: GitHub issues only. Stack: frontend, backend, or full-stack. If the user asks for another strategy or tracker, say it is not supported yet and stop; do not improvise.

All source material is in this skill's `references/` folder. **Never clone, fetch, or link any external template repository**, and do not write links to one into the generated files.

## References

| File | Used for |
|---|---|
| `references/core/claude-md.md` | `CLAUDE.md` |
| `references/core/architecture.md` | `docs/ARCHITECTURE.md` |
| `references/core/trouble-shooting.md` | `docs/TROUBLE_SHOOTING.md` |
| `references/core/gitignore.md` | `.gitignore` lines, `docs/history/.gitkeep` |
| `references/strategies/presets.md`, `feature-strategy.md` | Strategy slot values and rules |
| `references/trackers/github.md` | Tracker slot values and issue rules |
| `references/project-skills/issue-start.md` | `.claude/skills/issue-start/SKILL.md` |

Slots are written `{{NAME}}`. Every slot must be replaced; no `{{` may remain in a written file.

## Steps

### 1. Pre-check (no writes)
1. Look at the current directory: is it empty? Is it a git repository? Note which of these exist: `CLAUDE.md`, `docs/ARCHITECTURE.md`, `docs/TROUBLE_SHOOTING.md`, `.claude/skills/issue-start/SKILL.md`, `.gitignore`, `README.md`, `package.json` and similar manifests.
2. **Existing files are never overwritten.** Mark each existing target as `skip`. An existing `README.md` is not a target; read it only to prefill interview answers.
3. **Re-run**: if `CLAUDE.md` contains the `ai-workflow:` marker, the project is already initialized. Read the strategy/tracker/stack from the marker, do not repeat the interview, and only offer to create targets that are still missing (for example a deleted `issue-start`). Then jump to step 4.
4. If `CLAUDE.md` exists without the marker, do not touch it; tell the user and offer to generate only the other missing files, or stop.

### 2. Interview
**Open with a clear banner before the first question**, so the user knows this is a guided interview and not an error: say that this is a 7-question setup interview, that nothing has been written yet, and that files are written only after the user approves a preview. Number every question ("Question 2/7"), and show your recommended answer on its own line. Speak in the user's language from the very first message (use the language of their earlier messages or the project's language setting); if it cannot be told, write the banner and first question in both English and Korean. Do not narrate internal steps such as reading references.

One question at a time, each with your recommended answer; skip anything already known from the pre-check. Wait for the answer before the next question. Order:

1. **Purpose and current scope** — what the project does and what is in scope now.
2. **Tech stack** — and whether it is **frontend / backend / full-stack** (ask directly if unclear). Language/framework, package manager, styling, state, routing, data fetching as relevant.
3. **Commands** — dev, build, lint, test commands. If the stack is not decided yet, write "to be decided after setup" instead of inventing commands.
4. **Directory structure** — an existing plan, or "decide with the scaffolding in `ai-workflow-setup`".
5. **Out of scope** — features intentionally excluded for now.
6. **Large-task workflow** — recommend `feature-strategy` (see `references/strategies/presets.md`). If the stack is backend-only, say `feature-strategy` is a frontend-oriented skill and let the user decide; the user's choice wins. If the user wants a strategy that is not listed, say it is not supported yet.
7. **Issue tracker** — GitHub issues (the only supported option here).

### 3. Preview and approval, then write
1. Build the contents in memory from the references: replace slots, apply the language rule below. Fill **only** the sections the user answered; if an answer is "not decided", write a short honest placeholder sentence in that section, not a `{{slot}}`.
2. Show the user a table: each file, `create` or `skip (already exists)`, and the substituted values (purpose, stack, strategy skill name, tracker, branch note). For `.gitignore`, list the lines that will be added. Show `issue-start` fully or its substituted lines.
3. **Ask for approval.** If the user declines, write nothing and stop; offer to change answers.
4. After approval, write: `CLAUDE.md`, `docs/ARCHITECTURE.md`, `docs/TROUBLE_SHOOTING.md`, `docs/history/.gitkeep`, `.claude/skills/issue-start/SKILL.md`, then append missing `.gitignore` lines. Use the Write tool only for files marked `create`.
5. The strategy skill name appears in exactly one place in `CLAUDE.md` and one place in `issue-start`. Strategy-specific locations and rules (feature document directory, sub-issues, branch/commit/PR rules) appear only in the block inserted from the strategy fragment.
6. **Marker**: the first line under the title of `CLAUDE.md` is `<!-- ai-workflow: version=1.4.0 strategy=<strategy> tracker=<tracker> stack=<frontend|backend|fullstack> -->`, so that later steps and `ai-workflow-setup` know the choices and which skill version generated the documents. Also keep `version=1.4.0` current when this skill changes.

### 4. Summary and next step
Report what was created and skipped (short list), then tell the user:

> Next, run `/ai-workflow-setup` (in a plugin install: `/dopeboy0608-skills:ai-workflow-setup`). It runs the scaffolding CLI for your stack, adds the directory structure, and checks the tools the workflow needs (`gh`, the `dopeboy0608-skills` plugin).

Do not run the other skill yourself; skills link only by this guidance. Do not commit, open PRs, or run scaffolding CLIs here.

## Language

Write generated documents in the language the user used in the interview. The references are in English; translate all prose and headings. For Korean, use these fixed section titles (this file is the one loaded at run time, so the table lives here):

| English | Korean |
|---|---|
| Project purpose / current scope | 프로젝트 목적 / 현재 범위 |
| Commands | 명령어 |
| Rules after writing code | 코드 작성 후 규칙 |
| Test harness criteria | 테스트 하네스 적용 기준 |
| Directory structure | 디렉터리 구조 |
| Tech stack | 기술 스택 |
| Prohibited | 금지 사항 |
| GitHub issue management | GitHub 이슈 관리 |
| Starting work on an issue | 이슈 작업 시작 워크플로우 |
| Large-task workflow: feature-strategy | 큰 작업 워크플로우: feature-strategy |
| Daily work history log | 일별 작업 히스토리 로그 |
| Troubleshooting log | 트러블슈팅 로그 |
| Current scope / Structure overview | 현재 구현 범위 / 구조 개요 |
| TDD criteria / Task routing criteria | TDD 적용 기준 / 작업 분기 기준 |
| External SDK mocking / Out of scope (future) | 외부 SDK 모킹 전략 / Out of scope (future) |

Keep file names, commands, label names (`in-progress`, ...), and skill names untranslated. The `issue-start` skill is written in the same language; its `name` stays `issue-start`.

## What this skill does not do

- Overwrite any existing file, or write anything before approval.
- Run scaffolding CLIs or install anything (that is `ai-workflow-setup`).
- Create `docs/spec/` or a "write the spec first" rule; small tasks work from the request or ticket, and large tasks are documented by the selected strategy.
- Commit, push, or open PRs.

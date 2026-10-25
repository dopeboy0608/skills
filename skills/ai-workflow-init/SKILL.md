---
name: ai-workflow-init
description: Bootstrap an AI coding workflow in a blank (or existing) project — through a short interview, generate CLAUDE.md rules, docs/ARCHITECTURE.md, docs/TROUBLE_SHOOTING.md and an issue-start skill (small task vs. large task routing with a choice of large-task strategy, GitHub issues). Never overwrites existing files and shows a preview before writing. Recommended for first-time adopters of an AI workflow or anyone who wants a minimal setup with little configuration. Run /ai-workflow-setup afterwards. Use only when invoked explicitly via /ai-workflow-init.
disable-model-invocation: true
---

# AI Workflow Init

Create the rule documents that let an AI agent work in a project the same way every time, starting from a blank directory. The skill interviews the user, shows the list of files it will write, and writes them only after approval. It never overwrites an existing file.

> **Recommended for** people adopting an AI workflow for the first time, and anyone who wants a minimal setup without complicated configuration.
>
> **Explicit invocation only.** Run only when the user calls `/ai-workflow-init`.
>
> **Scope of this version.** Large-task workflow: `feature-strategy`, `speckit`, a skill name the user types, or none. Issue tracker: GitHub issues, none (local documents only), or another tracker the user names (delegated, nothing tool-specific is written). Stack: frontend, backend, or full-stack. Do not improvise beyond these options.

All source material is in this skill's `references/` folder. **Never clone, fetch, or link any external template repository**, and do not write links to one into the generated files.

## References

| File | Used for |
|---|---|
| `references/core/claude-md.md` | `CLAUDE.md` |
| `references/core/architecture.md` | `docs/ARCHITECTURE.md` |
| `references/core/trouble-shooting.md` | `docs/TROUBLE_SHOOTING.md` |
| `references/core/gitignore.md` | `.gitignore` lines, `docs/history/.gitkeep` |
| `references/strategies/presets.md` | Strategy table, stack-based recommendation, fragment contract |
| `references/strategies/feature-strategy.md`, `speckit.md`, `custom.md`, `none.md` | Only the fragment of the **selected** strategy is read and used |
| `references/trackers/github.md`, `none.md`, `custom.md` | Only the fragment of the **selected** tracker is read and used (slot values for `issue-start`, the tracker rules block for CLAUDE.md) |
| `references/project-skills/issue-start.md` | `.claude/skills/issue-start/SKILL.md` |

Slots are written `{{NAME}}`. Every slot must be replaced; no `{{` may remain in a written file.

## Steps

### 1. Pre-check (no writes)
1. Look at the current directory: is it empty? Is it a git repository? Note which of these exist: `CLAUDE.md`, `docs/ARCHITECTURE.md`, `docs/TROUBLE_SHOOTING.md`, `.claude/skills/issue-start/SKILL.md`, `.gitignore`, `README.md`, `package.json` and similar manifests.
2. **Existing files are never overwritten.** Mark each existing target as `skip`. An existing `README.md` is not a target; read it only to prefill interview answers.
3. **Re-run**: if `CLAUDE.md` contains the `ai-workflow:` marker, the project is already initialized. Read the strategy/tracker/stack/lang from the marker, do not repeat the interview, and only offer to create targets that are still missing (for example a deleted `issue-start`). Then jump to step 4.
4. If `CLAUDE.md` exists without the marker, do not touch it; tell the user and offer to generate only the other missing files, or stop.

### 2. Interview
**Open with a clear banner before the first question**, so the user knows this is a guided interview and not an error: say that this is an 8-question setup interview, that nothing has been written yet, and that files are written only after the user approves a preview. Number every question ("Question 2/8"), and show your recommended answer on its own line. Speak in the user's language from the very first message (use the language of their earlier messages or the project's language setting); if it cannot be told, write the banner and first question in both English and Korean. Do not narrate internal steps such as reading references.

**Output of every turn in the interview is only: the question, then the recommended answer.** Never write sentences like "I will record X and then ask about Y", "the project is empty so nothing is skipped", or a restatement of the previous answer; at most one short acknowledgment word. The recommended answer is a separate line in the form `Recommended: <answer>` (in the user's language), under every question including questions 1–5; if there is nothing sensible to recommend, offer the most common answer.

**Question format** (use it for every question so the interview looks the same each time; translate the labels to the user's language):

```
### Question 3/8 · Tech stack
One line on why this is asked (what it decides later).

1. Frontend  ← recommended
2. Backend
3. Full-stack

> Recommended: 1. Frontend — one short reason.
```

Use a numbered list whenever there is a fixed set of choices, mark the recommended one with `← recommended`, and keep the whole question under ~8 lines. Free-text questions skip the list and keep the title, one-line reason, and the `> Recommended:` line.

One question at a time, each with your recommended answer; skip anything already known from the pre-check. Wait for the answer before the next question. Order:

1. **Document language** — the language of the generated documents (`CLAUDE.md`, `docs/`, the `issue-start` skill). Offer `English`, `한국어`, and "other (type the language)", recommend the language the user has been writing in, and say that code, commands, file names, and skill names stay as they are. The interview itself continues in the user's language. Record the choice as `lang=<en|ko|code>` in the marker.
2. **Purpose and current scope** — what the project does and what is in scope now.
3. **Tech stack** — when asking, say plainly that **this workflow is optimized for frontend projects** (the directory layout, tool recommendations, and `feature-strategy` are frontend-oriented); backend and full-stack work too, with more general defaults. Asked before the strategy because the strategy recommendation depends on it; and whether it is **frontend / backend / full-stack** (ask directly if unclear). Language/framework, package manager, styling, state, routing, data fetching as relevant.
4. **Commands and quality tools** — dev, build commands, plus the **formatter/linter** and **test runner** the project will use (these make the "format/lint after coding" and "run tests" rules in `CLAUDE.md` executable). Recommend by stack: frontend → Biome and Vitest + Testing Library; backend → the stack's standard pair (for example ruff + pytest). If the stack is not decided yet, write "to be decided after setup" instead of inventing commands; `ai-workflow-setup` will offer the tools when it installs the environment. Record the chosen tool names in `CLAUDE.md` "Commands" and "Tech stack" as planned, not as installed.
5. **Directory structure** — an existing plan, or "decide with the scaffolding in `ai-workflow-setup`".
6. **Out of scope** — features intentionally excluded for now.
7. **Large-task workflow** — ask this **after** the tech stack (question 3) is known; if the stack was "not decided", ask frontend / backend / full-stack first. Offer four options and put the stack-based recommendation first (see `references/strategies/presets.md`):
   - Frontend / full-stack → recommend `feature-strategy`. For a **frontend-only** stack do not offer "none"; if the user asks for it, explain that frontend projects always keep a large-task path and use `feature-strategy` (`speckit` or direct input are still allowed).
   - Backend only → say `feature-strategy` is a frontend-oriented skill and recommend `speckit`, direct input, or none instead; if the user still picks `feature-strategy`, follow it.
   - Show each option with the one-line description from `references/strategies/presets.md` ("One-line descriptions"), and for the recommended `feature-strategy` say in one sentence what it does before recommending it.
   - `speckit` (Spec Kit; needs the `specify` CLI, which you install yourself; `ai-workflow-setup` shows the commands and detects the result), **direct input** (ask for the skill name), **none** (every issue is implemented directly, no large-task path).
8. **Issue tracker** — three options, GitHub issues recommended:
   - **GitHub issues** (recommended): issues, labels, and sub-issues are managed with the `gh` CLI.
   - **None**: local documents only; no issues, labels, or `gh`. Large tasks are tracked in the strategy's documents (with `feature-strategy`, the feature document is the single source and sub-tasks are numbered `01`, `02`, …).
   - **Other (Jira, Linear, ...)**: ask for the tracker name only. The generated documents say to use that tracker's own tools; no tool-specific commands are written.
   Show the three options with these one-line descriptions. Nothing about the trackers that were not selected may appear in any generated file.

### 3. Preview and approval, then write
1. Build the contents in memory from the references: replace slots, apply the language rule below. Fill **only** the sections the user answered; if an answer is "not decided", write a short honest placeholder sentence in that section, not a `{{slot}}`.
2. Show the user a table: each file, `create` or `skip (already exists)`, and the substituted values (purpose, stack, strategy skill name, tracker, branch note). For `.gitignore`, list the lines that will be added. Show `issue-start` fully or its substituted lines.
3. **Ask for approval.** If the user declines, write nothing and stop; offer to change answers.
4. After approval, write: `CLAUDE.md`, `docs/ARCHITECTURE.md`, `docs/TROUBLE_SHOOTING.md`, `docs/history/.gitkeep`, `.claude/skills/issue-start/SKILL.md`, then append missing `.gitignore` lines. Use the Write tool only for files marked `create`.
5. The strategy skill name appears in exactly one place in `CLAUDE.md` and one place in `issue-start`. Strategy-specific locations and rules (feature document directory, sub-issues, branch/commit/PR rules) appear only in the block inserted from the selected strategy fragment. Read only that fragment: nothing about a strategy that was not selected may appear in any generated file. For `none`, apply the edits listed in `strategies/none.md` and use the "no strategy" variant of `issue-start`.
6. **Marker**: the first line under the title of `CLAUDE.md` is `<!-- ai-workflow: version=1.4.5 strategy=<feature-strategy|speckit|custom:<skill-name>|none> tracker=<github|none|custom:<name>> stack=<frontend|backend|fullstack> lang=<en|ko|code> -->`, so that later steps and `ai-workflow-setup` know the choices and which skill version generated the documents. Also keep `version=1.4.3` current when this skill changes.

### 4. Summary and next step
Report what was created and skipped (short list), then tell the user:

> Next, run `/ai-workflow-setup` (in a plugin install: `/dopeboy0608-skills:ai-workflow-setup`). It runs the scaffolding CLI for your stack, adds the directory structure, and checks the tools the workflow needs (`gh`, the `dopeboy0608-skills` plugin).

State the **requirement of the selected strategy** (from its fragment's "Requires" line) in the summary, for example: "The large-task path only works once `speckit` is installed; `/ai-workflow-setup` will check it." For `none`, say that large issues are not routed anywhere and should be split first. Do not mention strategies that were not selected.

Do not name unselected strategies anywhere in the chat summary either, not even to say that no trace of them remains; say only "no leftover `{{slots}}`".

Do not run the other skill yourself; skills link only by this guidance. Do not commit, open PRs, or run scaffolding CLIs here.

## Language

Write generated documents in the **document language chosen in question 1** (not necessarily the language of the chat). The references are in English; translate all prose and headings into that language. For English, keep the headings as written in the references. For Korean, use these fixed section titles (this file is the one loaded at run time, so the table lives here). For any other language, translate the headings the same way and keep the meaning of each section.

| English | Korean |
|---|---|
| Project purpose / current scope | 프로젝트 목적 / 현재 범위 |
| Commands | 명령어 |
| Rules after writing code | 코드 작성 후 규칙 |
| Test harness criteria | 테스트 하네스 적용 기준 |
| Directory structure | 디렉터리 구조 |
| Tech stack | 기술 스택 |
| Prohibited | 금지 사항 |
| GitHub issue management / Work tracking / Issue tracker: `<name>` | GitHub 이슈 관리 / 작업 관리 / 이슈 트래커: `<name>` |
| Starting work on an issue | 이슈 작업 시작 워크플로우 |
| Large-task workflow: `<strategy>` (`feature-strategy`, `speckit`, `custom skill`) | 큰 작업 워크플로우: `<strategy>` (`custom skill` → 사용자 지정 스킬) |
| Keeping these documents in sync | 문서 동기화 규칙 |
| Daily work history log | 일별 작업 히스토리 로그 |
| Troubleshooting log | 트러블슈팅 로그 |
| Current scope / Structure overview | 현재 구현 범위 / 구조 개요 |
| TDD criteria / Task routing criteria | TDD 적용 기준 / 작업 분기 기준 |
| External SDK mocking / Out of scope (future) | 외부 SDK 모킹 전략 / Out of scope (future) |

Keep file names, commands, label names (`in-progress`, ...), and skill names untranslated. The `issue-start` skill is written in the same language; its `name` stays `issue-start`.

## What this skill does not do

- Overwrite any existing file, or write anything before approval.
- Run scaffolding CLIs or install anything (that is `ai-workflow-setup`).
- Install a strategy's tool or skill (that is `ai-workflow-setup`, with approval).
- Create `docs/spec/` or a "write the spec first" rule; small tasks work from the request or ticket, and large tasks are documented by the selected strategy.
- Commit, push, or open PRs.

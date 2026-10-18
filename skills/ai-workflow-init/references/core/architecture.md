# docs/ARCHITECTURE.md template

Fill the slots from the interview, translate into the user's language, and write the content between the markers.

Slots: `{{SCOPE}}`, `{{STRUCTURE_OVERVIEW}}`, `{{TECH_STACK}}` (or a pointer to CLAUDE.md), `{{OUT_OF_SCOPE}}`.

If the strategy is `none`, replace the "Task routing criteria" section as described in `strategies/none.md`.

---BEGIN---
# ARCHITECTURE

> Holds the criteria that CLAUDE.md refers to (test harness criteria, task routing criteria). When a criterion changes, edit this file first; do not copy criteria into CLAUDE.md or skill files.

## Current scope

{{SCOPE}}

## Structure overview

{{STRUCTURE_OVERVIEW}}

## Tech stack

{{TECH_STACK}}

## TDD criteria

- **TDD target**: pure functions with clear inputs/outputs and no side effects. Write the test first, then implement.
  - Typical cases: functions that convert external API responses into internal models, coordinate/unit conversions; anything whose inputs and expected outputs are fixed and that has no network or DOM dependency.
- **Not a TDD target**: UI components, side-effect-centered hooks, HTTP interceptors, and other code that depends on external state or environment. Clarify the expected behavior from the request or ticket first, and verify afterwards with integration/component tests when needed.

## Task routing criteria

`issue-start` applies these signals to recommend one of two paths and asks the user to confirm. The recommendation is a hint, not a rule; the user decides.

- **Large task** (use the strategy skill): requirements are ambiguous or need investigation first / the scope is big enough to split into several sub-tasks / the work is design-heavy or has decision points that need the user's judgment.
- **Small task** (implement directly): a bug whose cause and fix are already clear / 1–2 files following an existing pattern / nothing to investigate.
- When an issue mixes both signals, decide by which one is closer to the core risk of the issue and explain briefly.
- Both paths follow the tracker and branch conventions in CLAUDE.md, and commit/PR/merge only on the user's explicit request (except where the strategy rules in CLAUDE.md say otherwise).

## External SDK mocking

SDKs that inject `<script>` tags or load asynchronously over the network (maps, payments, editors, ...) never finish loading or leave globals undefined in test environments such as jsdom. Approach by test target:

- **Pure logic tests**: no need to imitate the real SDK. Plant a minimal mock on the global that implements only the APIs the code under test uses; add APIs only as needed (never recreate the whole SDK).
- **Component tests**: use module mocks (`vi.mock`, etc.) so the initialization hook returns a ready state immediately, and replace SDK-provided components with simple components that are easy to assert on.

{{SDK_MOCK_NOTES}}

## Out of scope (future)

{{OUT_OF_SCOPE}}
---END---

`{{SDK_MOCK_NOTES}}`: leave out when the project uses no such SDK (remove the line); otherwise name the mock files/functions.

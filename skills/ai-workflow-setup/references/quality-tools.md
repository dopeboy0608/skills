# Quality tools (setup step 2c)

The rules in `CLAUDE.md` ("run the formatter/linter after writing code", "run the tests", TDD, API mocking) only work when these tools exist. Offer them right after the dependencies are installed. The choice may already be written in `CLAUDE.md` "Commands" / "Tech stack" from the init interview; if so, install exactly that and do not ask again.

Detect before offering: if the project already has a formatter/linter, test runner, or the matching `package.json` script, skip that row entirely and write the existing command into `CLAUDE.md` in step 3b. Never install a second tool of the same kind next to an existing one.

Each tool is a separate yes/no. Show the exact install command, the config file it will add, and the scripts it will add to the manifest. Nothing runs without approval; if the user declines, leave a one-line note in the report that the matching `CLAUDE.md` rule cannot be followed yet.

## Frontend (Node, using the project's package manager `<pm>`)

| Purpose | Recommended | Alternative | Install | Scripts added to `package.json` |
|---|---|---|---|---|
| Formatter + linter | Biome (one tool, one config) | ESLint + Prettier (pick if the user already uses them) | `<pm> add -D -E @biomejs/biome`, then `biome init` | `"lint": "biome check ."`, `"format": "biome format --write ."` |
| Test runner | Vitest + Testing Library + jsdom | Jest | `<pm> add -D vitest jsdom @testing-library/react @testing-library/jest-dom @testing-library/user-event` | `"test": "vitest run"`, `"test:watch": "vitest"` |
| API mocking | MSW, only when the scope includes calls to an external API | none | `<pm> add -D msw` | none |
| Type check | the TypeScript already installed | none | none | `"typecheck": "tsc --noEmit"` (only if `tsconfig.json` exists) |
| Pre-commit hook (optional, ask separately) | husky + lint-staged | none | `<pm> add -D husky lint-staged`, then `husky init` | `"prepare": "husky"`; lint-staged config runs the linter on staged files |

Test config: add the minimal config file the runner needs (for example `environment: "jsdom"` and a setup file importing `@testing-library/jest-dom`), and one trivial passing test only if the user agrees, so `test` does not fail on "no tests found". Do not write feature tests here.

## Backend

Offer the stack's standard pair, same rules as above: Python → `ruff` (lint + format) and `pytest`; Node/Nest → Biome or ESLint + Prettier, and Vitest or Jest; Go → `gofmt`/`go vet` (built in) and `go test` (built in, nothing to install); other stacks → ask what the team uses and write it down without installing.

## After installing

1. Run the new `lint` and `test` scripts once and report the real result (pass / fail / "no tests"). Run only **non-writing** checks (`biome check .`, not `--write`/`format --write`) over existing files. Re-indenting or rewriting the generator's sample files (`src/App.tsx`, `tsconfig.json`, ...) makes a large noisy diff; offer it as a separate approved step ("Format existing files now?") and say how many files would change. Do not hide failures; do not "fix" the sample code from the generator without asking.
2. Show the before/after of `CLAUDE.md` "Commands" (dev, build, lint, format, test, typecheck with the real script names) and "Tech stack" and write them after approval (this is step 3b).
3. Remind the user to commit the config files, the manifest, and the lockfile.

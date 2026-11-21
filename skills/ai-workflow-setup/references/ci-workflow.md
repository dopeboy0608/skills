# CI workflow (setup step 2d)

Offered only when the repository's remote is GitHub (check `git remote get-url origin`; the issue tracker may be anything), the project has a manifest, and at least one of the `lint` / `typecheck` / `test` / `build` scripts exists (after step 2c). It makes "tests pass before merge" a team-level check instead of a local habit. If `.github/workflows/` already has a workflow that runs these scripts, report it and skip.

Ask once: "Add a GitHub Actions CI workflow that runs lint, typecheck, test and build on pull requests?" Show the file before writing; write `.github/workflows/ci.yml` only after a yes. Never overwrite an existing `ci.yml`.

## Frontend / Node template

Include a step only for scripts that exist in `package.json`; never add a step that would fail with "script not found". Use the project's package manager. Pin the Node version from `.nvmrc` if present, otherwise `lts/*`. Keep the workflow to lint, typecheck, test and build; do not add deploy steps.

```yaml
name: CI
on:
  pull_request:
  push:
    branches: [<default branch>]
jobs:
  check:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      # pnpm only; reads the version from the packageManager field of package.json
      - uses: pnpm/action-setup@v4
      - uses: actions/setup-node@v4
        with:
          node-version: lts/*
          cache: pnpm            # npm / yarn for the other managers
      - run: pnpm install --frozen-lockfile   # npm ci / yarn --immutable
      - run: pnpm run lint
      - run: pnpm run typecheck
      - run: pnpm run test
      - run: pnpm run build
```

If `package.json` has no `packageManager` field and the manager is pnpm, the `pnpm/action-setup` step needs a `version:`; add the field (`pnpm --version` gives the value) after asking, instead of guessing a version.

## Backend

Offer a CI file only when the stack's test and lint commands are known and installed (for example Python: `ruff check .` and `pytest`; Go: `go vet ./...` and `go test ./...`). Otherwise skip and mention it in the report.

## Report

Say that the workflow file is new and uncommitted, and that its first real run happens when the user pushes.

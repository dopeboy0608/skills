# FE scaffold reference

A structure that groups features by domain and pulls out only what several domains share into one place, `common/`. Even a small single-domain project benefits: adding domains later costs less refactoring.

```
src/
  pages/                    # screen components rendered by routes
  features/
    <domain>/               # one per domain (e.g. auth, map, payment)
      components/
      hooks/
      queries/              # domain-only data-fetching hooks (when needed)
      store/                # domain-only state management (when needed)
      types.ts              # domain-only types (when needed)
      constants.ts          # domain-only constants (when needed)
  common/                   # everything shared across domains lives here
    components/             # purely shared UI components used by several features
    hooks/                  # shared hooks (when needed)
    utils/                  # shared pure utilities (when needed)
    types/                  # types shared across domains (when needed)
    constants/              # constants shared across domains (when needed)
  routes/                   # router definitions (paths/loaders); only renders pages/ thinly
  api/                      # shared network layer such as the API client (domain-only fetching hooks live in features/*/queries)
  store/                    # global state (domain-only state lives in features/*/store)
  assets/                   # static assets such as svg/images
```

## Notes

- Anything used by two or more domains goes under `common/`, grouped by kind (`components/`, `hooks/`, `utils/`, `types/`, `constants/`). Later shared files (utilities, types, constants) then have one obvious home instead of scattering at the top of `src/`.
- Create the subfolders of `common/` and the domain-only subfolders (`queries/`, `store/`, `types.ts`, `constants.ts`) when they become necessary. At setup time, create only `common/components/` (and the domain folders the user names); do not create all of them as empty folders up front.
- Do not confuse `common/components/` (shared) with `features/<domain>/components/` (domain-only). Promote a component to `common/` once two or more features use it; likewise move a domain-only type or constant to `common/types/` or `common/constants/` when a second domain needs it.
- Do not leave API call logic inline in components/hooks; split it into utility functions under `api/`.

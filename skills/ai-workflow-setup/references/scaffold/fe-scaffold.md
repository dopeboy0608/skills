# FE scaffold reference

A structure that groups features by domain and pulls out only what several domains share. Even a small single-domain project benefits: adding domains later costs less refactoring.

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
  components/               # purely shared UI components used by several features
  routes/                   # router definitions (paths/loaders); only renders pages/ thinly
  api/                      # shared network layer such as the API client (domain-only fetching hooks live in features/*/queries)
  store/                    # global state (domain-only state lives in features/*/store)
  types/                    # types shared across domains
  constants/                # constants shared across domains
  assets/                   # static assets such as svg/images
```

## Notes

- Create the domain-only subfolders (`queries/`, `store/`, `types.ts`, `constants.ts`) when they become necessary; do not create all of them as empty folders up front.
- Do not confuse `components/` (shared) with `features/<domain>/components/` (domain-only). Promote a component to shared once two or more features use it.
- Do not leave API call logic inline in components/hooks; split it into utility functions under `api/`.

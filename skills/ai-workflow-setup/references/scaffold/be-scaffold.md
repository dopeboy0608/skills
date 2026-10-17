# BE scaffold reference

A structure that separates request handling (routes) → business logic (services) → data access (repositories). Folder names vary by framework (Express/Nest/FastAPI, ...); treat this as a role-based skeleton.

```
src/
  routes/           # or controllers/ — request/response mapping and input validation only
  services/         # business logic; combines repositories to implement use cases
  repositories/     # data access layer (DB, external APIs); keep query/call logic here
  models/           # domain models, DTOs, schema types
  middlewares/      # cross-cutting concerns: auth, error handling, logging
  config/           # environment variables, external service client initialization
  utils/            # pure utilities shared by several layers
test/               # or __tests__/ next to each layer folder
```

## Notes

- Keep routes/controllers thin; delegate business logic to services instead of writing it there.
- repositories encapsulate ORM / query builder / external API client calls so services need not know how data is fetched.
- When the domain grows (several resources that rarely mix), consider a domain-first layout such as `features/<domain>/{routes,services,repositories}`. This reference targets a small-to-medium single service.

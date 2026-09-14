# Standards — Branching Conventions

## Branch model

```
main          ← production branch (protected, merge only via PR)
develop       ← integration branch (optional depending on project size)
feat/*        ← new features
fix/*         ← bug fixes
docs/*        ← documentation
chore/*       ← maintenance, refactoring
hotfix/*      ← urgent production fixes
```

## Rules

- `main` is protected: no direct push, PR required
- PRs on `main` require at least 1 approval
- PRs must pass CI checks before merge
- Delete branches after merge
- Name branches in lowercase kebab-case: `feat/my-component`

## Naming conventions

```
<type>/<short-description>

Examples:
  feat/auth-jwt
  fix/memory-leak-cache
  docs/adr-0002-database-choice
  chore/update-dependencies
```

## Conventional commits

Format: `<type>(<scope>): <description>`

Accepted types:
- `feat` — new feature
- `fix` — bug fix
- `docs` — documentation
- `chore` — maintenance
- `refactor` — refactoring with no behavior change
- `test` — adding/modifying tests
- `ci` — CI/CD
- `build` — build system
- `perf` — performance improvement
- `style` — formatting

Examples:
```
feat(auth): add JWT token refresh
fix(api): handle null response from external service
docs(adr): add ADR-0002 database selection
chore: update awesome-copilot to dae77f24
```

## Branch Protection (GitHub)

Configure via GitHub Settings > Branches:
- Required status checks: `ci`, `governance-check`
- Require pull request reviews: 1
- Dismiss stale pull request approvals
- Require conversation resolution before merging
- Do not allow bypassing the above settings

# Commit Conventions — itshaker

## Format

```
<type>(<scope>): <description>

[optional body]

[optional footer]
```

## Allowed types

| Type | Usage |
|------|-------|
| `feat` | New feature |
| `fix` | Bug fix |
| `docs` | Documentation only |
| `style` | Formatting (no functional change) |
| `refactor` | Refactoring with no feature added and no fix |
| `perf` | Performance improvement |
| `test` | Adding or modifying tests |
| `chore` | Maintenance, build, dependencies |
| `ci` | CI/CD changes |
| `revert` | Revert of a previous commit |
| `security` | Security fix |

## Rules

- **Title line ≤ 72 characters**
- **Imperative mood**: "Add feature" not "Added feature"
- **No capital letter** after the type
- **No trailing period**
- **Optional but recommended scope**: `feat(auth):`, `fix(api):`
- **Breaking changes**: add `!` after the type/scope and describe in the footer

## Examples

```bash
feat(agents): add adr-generator agent integration
fix(auth): resolve token refresh race condition
docs(api): update OpenAPI spec for /users endpoint
chore: update dependencies to latest patch versions
refactor(core)!: extract config module — breaking change in config path
```

## Recommended tools

- [Commitizen](https://commitizen-tools.github.io/commitizen/)
- [Conventional Commits](https://www.conventionalcommits.org/)
- Pre-commit hook: `commitlint` or equivalent

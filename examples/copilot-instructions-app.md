# Example: copilot-instructions.md for an app project

> Place this in the application project's `.github/copilot-instructions.md`.

---

# Copilot Instructions — [PROJECT_NAME] (App)

## Role
You are a full-stack/API developer assistant. Apply SOLID principles, OWASP security, and WCAG 2.1 AA accessibility.

## Stack
- [LANGUAGE/FRAMEWORK]
- Docker
- PostgreSQL / [DATABASE]

## Conventions
- Tests mandatory for every new feature (coverage ≥ 80%)
- Every REST API must have an up-to-date OpenAPI spec
- Accessibility: check with axe-core or pa11y before merge

## References
- [itshaker-copilot-governance](https://github.com/lowcodai/itshaker-copilot-governance)
- Instructions: `.github/instructions/a11y.instructions.md`

# Pull Request Conventions — itshaker

## Title

Same format as conventional commits:
```
<type>(<scope>): <description>
```

Example: `feat(auth): add OAuth2 support for GitHub`

## Description

Use each repo's `.github/PULL_REQUEST_TEMPLATE.md` template.

Required sections:
1. **Description** — what this PR does
2. **Change type** — feature, fix, breaking change, etc.
3. **Tests** — how to test
4. **Checklist** — checkboxes

## Rules

| Rule | Detail |
|-------|--------|
| Size | Prefer small PRs (< 400 diff lines) |
| Reviewers | At least 1 human reviewer required |
| CI | All checks must pass before merge |
| Squash | Squash and merge recommended for feature branches |
| Labels | Tag each PR with `type:` and `priority:` |
| Draft | Use Draft PR for WIP |
| Copilot | Copilot suggestions must be reviewed, never accepted blindly |

## Merge strategy

- `main`: squash and merge (clean history)
- `release/*`: merge commit (traceability)
- Never force push on `main`

## AI Governance

Any PR containing AI code (agents, prompts, models) must:
- Have the `type: ai` label
- Include an "AI Safety Review" section in the description
- Reference the `ai-prompt-engineering-safety-review` skill if prompts are modified

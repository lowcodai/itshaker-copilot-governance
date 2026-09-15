# Copilot Instructions Examples — AI Project

> Copy this file into the target project's `.github/copilot-instructions.md`

```markdown
# Copilot Instructions — {{REPO_NAME}}

## Project Context
AI project using [describe: LLM, MCP, RAG, agents...].

## AI Security Constraints
- Always apply responsible prompt engineering principles
- Check compliance with the OWASP Top 10 for LLMs
- Document model decisions in an ADR
- Session-auto-commit only on feature branches, never on main

## Available Agents
- `@ai-readiness-reporter` — AI Readiness maturity report
- `@agent-governance-reviewer` — Agent governance review
- `@ai-team-dev` — AI development team
- `@adr-generator` — Architecture Decision Records

## Prompt Standards
- No sensitive data in prompts
- Document prompts in prompts/
- Version prompts with the code
- Evaluate prompts with arize-evaluator if applicable

## Governance
Reference: https://github.com/lowcodai/vibecoding-copilot-governance/policies/ai-usage-policy.md
```

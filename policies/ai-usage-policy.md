# Policy — AI Usage and Agent Governance

## Principles

1. **Transparency** — Any AI-generated code must be identified
2. **Human review** — All AI-generated code must be reviewed by a human before merge
3. **No secrets** — Never include secrets in Copilot prompts or contexts
4. **Compliance** — Agents must comply with security policies
5. **Traceability** — AI-generated architecture decisions are documented in an ADR

## Accepted usage

- Boilerplate and CRUD code generation
- Refactoring suggestions
- Unit test generation
- Documentation and comments
- AI-assisted code review
- ADR generation with the `adr-generator` agent

## Prohibited usage

- Including API keys, tokens, or passwords in prompts
- Publishing generated content without human review
- Using agents to make architecture decisions without human validation
- Enabling `session-auto-commit` on the `main` branch

## Active governance hooks

See `docs/awesome-copilot-map.md` for the full hooks registry.

## AI governance review

For AI projects, use the `agent-governance-reviewer` agent regularly:
- Before every release
- After adding a new LLM
- After modifying agents or prompts

# Exemples d'instructions Copilot — Projet IA

> Copier ce fichier dans `.github/copilot-instructions.md` du projet cible

```markdown
# Instructions Copilot — {{REPO_NAME}}

## Contexte du projet
Projet IA utilisant [décrire: LLM, MCP, RAG, agents...].

## Contraintes de sécurité IA
- Toujours appliquer les principes du prompt engineering responsable
- Vérifier la conformité OWASP Top 10 for LLMs
- Documenter les décisions de modèles en ADR
- Session-auto-commit uniquement sur branches feature, jamais sur main

## Agents disponibles
- `@ai-readiness-reporter` — Rapport de maturité AI Readiness
- `@agent-governance-reviewer` — Revue de gouvernance des agents
- `@ai-team-dev` — Équipe de développement IA
- `@adr-generator` — Architecture Decision Records

## Standards de prompts
- Pas de données sensibles dans les prompts
- Documenter les prompts dans prompts/
- Versionner les prompts avec le code
- Évaluer les prompts avec arize-evaluator si applicable

## Gouvernance
Référencer: https://github.com/lowcodai/itshaker-copilot-governance/policies/ai-usage-policy.md
```

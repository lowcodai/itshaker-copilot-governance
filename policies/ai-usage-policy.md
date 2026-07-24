# Politique — Usage de l'IA et gouvernance des agents

## Principes

1. **Transparence** — Toute génération de code par IA doit être identifiée
2. **Revue humaine** — Tout code généré par IA doit être relu par un humain avant merge
3. **Pas de secrets** — Ne jamais inclure de secrets dans les prompts ou contextes Copilot
4. **Conformité** — Les agents doivent respecter les politiques de sécurité
5. **Traçabilité** — Les décisions d'architecture générées par IA sont documentées en ADR

## Utilisation acceptée

- Génération de code boilerplate et CRUD
- Suggestions de refactoring
- Génération de tests unitaires
- Documentation et commentaires
- Revue de code assistée
- Génération d'ADR avec l'agent `adr-generator`

## Utilisation interdite

- Inclure des clés API, tokens ou mots de passe dans les prompts
- Publier du contenu généré sans relecture humaine
- Utiliser des agents pour prendre des décisions d'architecture sans validation humaine
- Activer `session-auto-commit` sur la branche `main`

## Hooks de gouvernance actifs

| Hook | Description | Activé par défaut |
|------|-------------|:------------------:|
| `tool-guardian` | Contrôle les outils utilisés | ✓ |
| `secrets-scanner` | Détecte les secrets | ✓ |
| `governance-audit` | Audit de gouvernance | ✓ |
| `session-logger` | Journalisation des sessions IA | Projets IA |
| `session-auto-commit` | Auto-commit (feature branch uniquement) | ✗ |

## Revue de gouvernance IA

Pour les projets IA, utiliser l'agent `agent-governance-reviewer` régulièrement :
- Avant chaque release
- Après ajout d'un nouveau modèle LLM
- Après modification des agents ou prompts

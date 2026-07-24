# Conventions de Pull Requests — itshaker

## Titre

Même format que les commits conventionnels :
```
<type>(<scope>): <description>
```

Exemple : `feat(auth): add OAuth2 support for GitHub`

## Description

Utiliser le template `.github/PULL_REQUEST_TEMPLATE.md` de chaque repo.

Sections obligatoires :
1. **Description** — ce que fait cette PR
2. **Type de changement** — feature, fix, breaking change, etc.
3. **Tests** — comment tester
4. **Checklist** — cases à cocher

## Règles

| Règle | Détail |
|-------|--------|
| Taille | Préférer des PRs petites (< 400 lignes de diff) |
| Reviewers | Au moins 1 reviewer humain obligatoire |
| CI | Tous les checks doivent passer avant merge |
| Squash | Squash and merge recommandé pour les branches feature |
| Labels | Étiqueter chaque PR avec `type:` et `priority:` |
| Draft | Utiliser Draft PR pour le WIP |
| Copilot | Les suggestions Copilot doivent être revues, pas acceptées aveuglément |

## Merge strategy

- `main` : squash and merge (historique propre)
- `release/*` : merge commit (traçabilité)
- Jamais de force push sur `main`

## Gouvernance IA

Toute PR contenant du code IA (agents, prompts, modèles) doit :
- Avoir le label `type: ai`
- Inclure une section "AI Safety Review" dans la description
- Référencer le skill `ai-prompt-engineering-safety-review` si des prompts sont modifiés

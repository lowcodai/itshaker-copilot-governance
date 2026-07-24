# Standards — Conventions de branches

## Modèle de branches

```
main          ← branche de production (protégée, merge uniquement via PR)
develop       ← branche d'intégration (optionnelle selon la taille du projet)
feat/*        ← nouvelles fonctionnalités
fix/*         ← corrections de bugs
docs/*        ← documentation
chore/*       ← maintenance, refactoring
hotfix/*      ← correctifs urgents en production
```

## Règles

- `main` est protégé : aucun push direct, PR obligatoire
- Les PRs sur `main` nécessitent au moins 1 approbation
- Les PRs doivent passer les checks CI avant merge
- Supprimer les branches après merge
- Nommer les branches en kebab-case minuscule : `feat/mon-composant`

## Conventions de nommage

```
<type>/<description-courte>

Exemples:
  feat/auth-jwt
  fix/memory-leak-cache
  docs/adr-0002-database-choice
  chore/update-dependencies
```

## Commits conventionnels

Format : `<type>(<scope>): <description>`

Types acceptés :
- `feat` — nouvelle fonctionnalité
- `fix` — correction de bug
- `docs` — documentation
- `chore` — maintenance
- `refactor` — refactoring sans changement de comportement
- `test` — ajout/modification de tests
- `ci` — CI/CD
- `build` — build system
- `perf` — amélioration de performance
- `style` — formatage

Exemples :
```
feat(auth): add JWT token refresh
fix(api): handle null response from external service
docs(adr): add ADR-0002 database selection
chore: update awesome-copilot to dae77f24
```

## Branch Protection (GitHub)

Configurer via GitHub Settings > Branches :
- Required status checks: `ci`, `governance-check`
- Require pull request reviews: 1
- Dismiss stale pull request approvals
- Require conversation resolution before merging
- Do not allow bypassing the above settings

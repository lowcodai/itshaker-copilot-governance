# Conventions de Commits — itshaker

## Format

```
<type>(<scope>): <description>

[corps optionnel]

[pied de page optionnel]
```

## Types autorisés

| Type | Usage |
|------|-------|
| `feat` | Nouvelle fonctionnalité |
| `fix` | Correction de bug |
| `docs` | Documentation uniquement |
| `style` | Formatage (pas de changement fonctionnel) |
| `refactor` | Refactoring sans ajout de feature ni fix |
| `perf` | Amélioration de performance |
| `test` | Ajout ou modification de tests |
| `chore` | Maintenance, build, dépendances |
| `ci` | Changements CI/CD |
| `revert` | Revert d'un commit précédent |
| `security` | Correctif de sécurité |

## Règles

- **Ligne de titre ≤ 72 caractères**
- **Impératif** : "Add feature" pas "Added feature"
- **Pas de majuscule** après le type
- **Pas de point final**
- **Scope optionnel** mais recommandé : `feat(auth):`, `fix(api):`
- **Breaking changes** : ajouter `!` après le type/scope et décrire en pied de page

## Exemples

```bash
feat(agents): add adr-generator agent integration
fix(auth): resolve token refresh race condition
docs(api): update OpenAPI spec for /users endpoint
chore: update dependencies to latest patch versions
refactor(core)!: extract config module — breaking change in config path
```

## Outils recommandés

- [Commitizen](https://commitizen-tools.github.io/commitizen/)
- [Conventional Commits](https://www.conventionalcommits.org/)
- Pré-commit hook : `commitlint` ou équivalent

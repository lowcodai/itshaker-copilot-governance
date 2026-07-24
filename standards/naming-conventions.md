# Conventions de Nommage — itshaker

## Repositories

| Pattern | Exemple | Usage |
|---------|---------|-------|
| `itshaker-template-<type>` | `itshaker-template-base` | Templates GitHub |
| `itshaker-<function>` | `itshaker-bootstrap` | Outils internes |
| `<projet>-<stack>` | `mon-api-node`, `mon-infra-aws` | Projets métier |

## Branches

| Pattern | Exemple | Usage |
|---------|---------|-------|
| `main` | `main` | Branche principale (protégée) |
| `feat/<slug>` | `feat/add-user-auth` | Nouvelles fonctionnalités |
| `fix/<slug>` | `fix/login-crash` | Corrections de bugs |
| `chore/<slug>` | `chore/update-deps` | Maintenance |
| `docs/<slug>` | `docs/update-api-spec` | Documentation |
| `hotfix/<slug>` | `hotfix/critical-security` | Correctifs urgents |

## Fichiers et répertoires

- **Fichiers** : `kebab-case` pour les fichiers Markdown et config, `snake_case` pour les scripts shell
- **Répertoires** : `kebab-case` (ex: `docs/adr/`, `my-module/`)
- **Secrets** : jamais dans les noms de fichiers, jamais commités

## Variables d'environnement

- `SCREAMING_SNAKE_CASE` (ex: `DATABASE_URL`, `API_KEY`)
- Préfixe par domaine : `GITHUB_*`, `APP_*`, `AWS_*`

## Labels GitHub

Voir `config/labels.yml` dans itshaker-bootstrap.

Format : `<catégorie>: <valeur>` (ex: `type: bug`, `priority: high`)

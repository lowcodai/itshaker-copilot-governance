# Politique de Protection des Branches — itshaker

## Règles pour `main`

À configurer via GitHub Branch Protection Rules ou Ruleset :

```yaml
# Via GitHub Rulesets (recommandé)
- require_pull_request: true
  required_approving_review_count: 1
  dismiss_stale_reviews: true
- require_status_checks: true
  required_checks:
    - ci
    - governance-check
- require_linear_history: false  # squash and merge suffit
- block_force_pushes: true
- block_deletions: true
- require_signed_commits: false  # optionnel, recommandé pour projets sensibles
```

## Configuration via GitHub CLI

```bash
gh api repos/{owner}/{repo}/branches/main/protection \
  --method PUT \
  --field required_status_checks='{"strict":true,"contexts":["ci"]}' \
  --field enforce_admins=false \
  --field required_pull_request_reviews='{"required_approving_review_count":1}' \
  --field restrictions=null
```

## Session Auto-Commit

Le hook `session-auto-commit` est **interdit sur `main`**.
Il ne doit jamais être configuré sans branche feature dédiée.

## Environnements de déploiement

Configurer des environnements GitHub avec protection pour `production` :
- Reviewers requis
- Wait timer recommandé (15 minutes minimum)

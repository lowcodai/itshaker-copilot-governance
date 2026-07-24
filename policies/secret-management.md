# Politique — Gestion des secrets

## Règles absolues

1. **Aucun secret dans le code source** — jamais, sans exception
2. **Aucun secret dans les variables d'environnement commiteées**
3. **Aucun secret dans les prompts Copilot ou contextes partagés**

## Où stocker les secrets

- **Développement local:** `.env` (dans `.gitignore`)
- **CI/CD:** GitHub Actions Secrets (`gh secret set`)
- **Production:** Secret Manager (AWS Secrets Manager, Azure Key Vault, HashiCorp Vault)

## Fichiers à toujours ignorer (.gitignore)

```
.env
.env.*
*.pem
*.key
*.p12
*_credentials.json
secrets.yml
secrets.yaml
```

## Vérification automatique

Le hook `secrets-scanner` (depuis awesome-copilot) scanne automatiquement les fichiers avant commit.

Patterns détectés :
- Clés AWS (`AKIA...`)
- Tokens GitHub (`ghp_...`, `gho_...`)
- Clés API génériques
- Mots de passe hardcodés
- Certificats privés

## En cas de secret leaké

1. Révoquer immédiatement le secret
2. Contacter l'équipe sécurité
3. Utiliser GitHub Secret Scanning pour identifier l'exposition
4. Réécrire l'historique git si nécessaire (procédure: `git filter-repo`)

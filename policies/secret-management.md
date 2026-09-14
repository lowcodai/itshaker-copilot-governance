# Policy — Secret Management

## Absolute rules

1. **No secrets in source code** — ever, no exception
2. **No secrets in committed environment variables**
3. **No secrets in Copilot prompts or shared contexts**

## Where to store secrets

- **Local development:** `.env` (in `.gitignore`)
- **CI/CD:** GitHub Actions Secrets (`gh secret set`)
- **Production:** Secret Manager (AWS Secrets Manager, Azure Key Vault, HashiCorp Vault)

## Files to always ignore (.gitignore)

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

## Automatic verification

The `secrets-scanner` hook (from awesome-copilot) automatically scans files before commit.

Detected patterns:
- AWS keys (`AKIA...`)
- GitHub tokens (`ghp_...`, `gho_...`)
- Generic API keys
- Hardcoded passwords
- Private certificates

## In case of a leaked secret

1. Revoke the secret immediately
2. Contact the security team
3. Use GitHub Secret Scanning to identify the exposure
4. Rewrite git history if necessary (procedure: `git filter-repo`)

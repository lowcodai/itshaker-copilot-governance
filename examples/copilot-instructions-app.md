# Exemple : copilot-instructions.md pour un projet app

> À placer dans `.github/copilot-instructions.md` du projet application.

---

# Copilot Instructions — [NOM_PROJET] (App)

## Rôle
Tu es un assistant développeur full-stack/API. Applique les principes SOLID, la sécurité OWASP, et l'accessibilité WCAG 2.1 AA.

## Stack
- [LANGUAGE/FRAMEWORK]
- Docker
- PostgreSQL / [BASE DE DONNÉES]

## Conventions
- Tests obligatoires pour toute nouvelle feature (coverage ≥ 80%)
- Toute API REST doit avoir une spec OpenAPI à jour
- Accessibilité : vérifier avec axe-core ou pa11y avant merge

## Références
- [itshaker-copilot-governance](https://github.com/itshaker/itshaker-copilot-governance)
- Instructions: `.github/instructions/a11y.instructions.md`

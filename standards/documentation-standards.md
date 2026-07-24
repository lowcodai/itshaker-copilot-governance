# Standards — Documentation

## Fichiers obligatoires dans chaque projet

| Fichier | Description | Où |
|---------|-------------|-----|
| `README.md` | Description, démarrage rapide, liens | Racine |
| `CHANGELOG.md` | Historique des versions (Keep a Changelog) | Racine |
| `BACKLOG.md` | Épics et stories du projet | Racine |
| `ROADMAP.md` | Vision et objectifs par version | Racine |
| `AGENTS.md` | Agents Copilot disponibles dans le projet | Racine |
| `CONTRIBUTING.md` | Guide de contribution | Racine |
| `SECURITY.md` | Politique de sécurité et signalement | Racine |
| `LICENSE` | Licence du projet | Racine |
| `docs/adr/` | Architecture Decision Records | docs/ |
| `.github/copilot-instructions.md` | Instructions Copilot pour le projet | .github/ |

## Architecture Decision Records (ADR)

Format : `ADR-XXXX-titre-en-kebab-case.md`

Structure d'un ADR :
```markdown
# ADR-XXXX — Titre de la décision

**Date:** YYYY-MM-DD
**Statut:** Proposé | En cours | Accepté | Rejeté | Obsolète | Remplacé par ADR-YYYY
**Décideurs:** <liste>

## Contexte
## Décisions
## Conséquences
## Références
```

Premiers ADR à créer :
- `ADR-0001` — Décisions initiales du projet (généré par `init-adr.sh`)
- `ADR-0002` — Choix de la stack technique

## CHANGELOG

Format [Keep a Changelog](https://keepachangelog.com/fr/1.0.0/) :
```markdown
## [Unreleased]
### Added
### Changed
### Deprecated
### Removed
### Fixed
### Security
```

## BACKLOG

Structure recommandée :
- **Épics** — grandes unités de valeur métier
- **Stories** — unités livrables d'une Epic
- **Icebox** — idées non planifiées

## ROADMAP

Structure recommandée par version :
```markdown
## v0.1-alpha — Objectif: ...
- [ ] Story 1
- [ ] Story 2

## v1.0 — Production Ready
- [ ] ...
```

# Exemple : copilot-instructions.md pour un projet infra

> À placer dans `.github/copilot-instructions.md` du projet infra.

---

# Copilot Instructions — [NOM_PROJET] (Infra)

## Rôle
Tu es un assistant DevOps/SRE. Applique les principes d'infrastructure-as-code, d'idempotence et de sécurité.

## Stack
- Ansible [VERSION]
- Docker [VERSION]
- GitHub Actions

## Conventions
- Toutes les tâches Ansible doivent être idempotentes
- Utiliser `ansible-lint` avant chaque PR
- Images Docker : toujours pinner par digest
- Secrets : via GitHub Secrets, jamais en clair

## Références
- [itshaker-copilot-governance](https://github.com/lowcodai/itshaker-copilot-governance)
- Instructions: `.github/instructions/ansible.instructions.md`

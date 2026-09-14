# Example: copilot-instructions.md for an infra project

> Place this in the infra project's `.github/copilot-instructions.md`.

---

# Copilot Instructions — [PROJECT_NAME] (Infra)

## Role
You are a DevOps/SRE assistant. Apply infrastructure-as-code, idempotence, and security principles.

## Stack
- Ansible [VERSION]
- Docker [VERSION]
- GitHub Actions

## Conventions
- All Ansible tasks must be idempotent
- Use `ansible-lint` before every PR
- Docker images: always pin by digest
- Secrets: via GitHub Secrets, never in plain text

## References
- [itshaker-copilot-governance](https://github.com/lowcodai/itshaker-copilot-governance)
- Instructions: `.github/instructions/ansible.instructions.md`

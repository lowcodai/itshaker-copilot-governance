# itshaker-copilot-governance

> Repository central de gouvernance — standards communs, instructions, hooks, policies, agents et références Awesome Copilot pour tous les projets itshaker.

## Rôle

Ce repository est la **source de vérité unique** pour :
- Les standards de développement et documentation
- Les instructions Copilot communes
- Les hooks de sécurité et gouvernance
- Les agents et skills recommandés
- Les politiques (licences, secrets, branching)
- Les templates ADR, BACKLOG, ROADMAP, ISSUE_TEMPLATE, PR_TEMPLATE

## Structure

```
itshaker-copilot-governance/
├── standards/          ← Conventions (branching, commits, PR, nommage, documentation)
├── instructions/       ← Fichiers .instructions.md issus de github/awesome-copilot
├── hooks/              ← Hooks Copilot (tool-guardian, secrets-scanner, etc.)
├── agents/             ← Fichiers .agent.md recommandés
├── skills/             ← Skills awesome-copilot (répertoires)
├── plugins/            ← Références plugins awesome-copilot
├── policies/           ← Politiques: IA, secrets, licences, branch protection
├── templates/          ← Templates ADR, BACKLOG, ROADMAP, ISSUE_TEMPLATE, PR_TEMPLATE
├── docs/               ← Documentation d'usage et stratégie
├── scripts/            ← Scripts utilitaires (sync-to-repo.sh)
└── examples/           ← Exemples de copilot-instructions.md par type de projet
```

## Utilisation

### Synchroniser la gouvernance dans un projet existant

```bash
# Depuis itshaker-bootstrap
./scripts/sync-governance.sh --type <base|infra|ai|app> --dest /chemin/vers/projet
```

### Mettre à jour les éléments awesome-copilot

```bash
./scripts/install-awesome-copilot.sh --type <type> --dest /chemin/vers/projet
```

## Source des éléments Copilot

- **Repository:** [github/awesome-copilot](https://github.com/github/awesome-copilot)
- **SHA de référence:** `dae77f24132c1d686c30fd5b29aee0d63668d1d2`
- **Installation skills:** `gh skills install github/awesome-copilot <skill-name>` (gh CLI v2.90.0+)
- **Installation plugins:** `copilot plugin install <name>@awesome-copilot`

## Matrice de répartition par type de projet

Voir [docs/awesome-copilot-map.md](docs/awesome-copilot-map.md)

## Mise à jour

Lorsque ce repository est mis à jour, relancer `sync-governance.sh` dans les projets impactés pour propager les changements.

```bash
# Mettre à jour un projet
cd /chemin/vers/itshaker-bootstrap
./scripts/sync-governance.sh --type infra --dest /chemin/vers/mon-projet --extend-only
```

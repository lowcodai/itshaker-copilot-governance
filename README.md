# itshaker-copilot-governance

> Central governance repository — shared standards, instructions, hooks, policies, agents, and Awesome Copilot references for all itshaker/lowcodai projects.

## Role

This repository is the **single source of truth** for:
- Development and documentation standards
- Shared Copilot instructions
- Security and governance hooks
- Recommended agents and skills
- Policies (licenses, secrets, branching)
- ADR, BACKLOG, ROADMAP, ISSUE_TEMPLATE, PR_TEMPLATE templates

## Structure

```
itshaker-copilot-governance/
├── standards/          ← Conventions (branching, commits, PR, naming, documentation)
├── instructions/       ← .instructions.md files sourced from github/awesome-copilot
├── hooks/              ← Copilot hooks (tool-guardian, secrets-scanner, etc.)
├── agents/             ← Recommended .agent.md files
├── skills/             ← awesome-copilot skills (directories)
├── plugins/            ← awesome-copilot plugin references
├── policies/           ← Policies: AI, secrets, licenses, branch protection
├── templates/          ← ADR, BACKLOG, ROADMAP, ISSUE_TEMPLATE, PR_TEMPLATE templates
├── hermes/             ← Hermes continuity contract (.hermes.md + docs/operations/ skeleton)
├── docs/               ← Usage and strategy documentation
├── scripts/            ← Utility scripts (sync-to-repo.sh)
└── examples/           ← Example copilot-instructions.md files by project type
```

## Hermes Continuity (`hermes/`)

Single source for the operational continuity contract used by Hermes sessions
(see ADR-0021 in `HermesVPS2`): checkpoint discipline under context pressure,
mandatory tracking files. Propagated to every project by
`sync-governance.sh` (the `sync_hermes` function), regardless of type (`base|infra|ai|app`)
— context continuity is not specific to a project type.

- `hermes/.hermes.md` — the contract itself, to be copied as-is to `<project>/.hermes.md`
  (fill in the `{{PROJECT_NAME}}` / `{{CONTEXT_WINDOW_TOKENS}}` placeholders once, in the
  target project, not in this source repo).
- `hermes/docs-operations-templates/{CURRENT,HANDOFF,ACTIVITY}.md` — empty skeletons to copy
  to `<project>/docs/operations/` **once only** (never overwrite a file already in use —
  `copy_if_not_exists`, the same logic as `sync_instructions`).


## Usage

### Sync governance into an existing project

```bash
# From itshaker-bootstrap
./scripts/sync-governance.sh --type <base|infra|ai|app> --dest /path/to/project
```

### Update awesome-copilot elements

```bash
./scripts/install-awesome-copilot.sh --type <type> --dest /path/to/project
```

## Source of Copilot elements

- **Repository:** [github/awesome-copilot](https://github.com/github/awesome-copilot)
- **Reference SHA:** `dae77f24132c1d686c30fd5b29aee0d63668d1d2`
- **Skill installation:** `gh skills install github/awesome-copilot <skill-name>` (gh CLI v2.90.0+)
- **Plugin installation:** `copilot plugin install <name>@awesome-copilot`
- **`instructions/`, `hooks/`, `agents/` populated on 2026-09-14** from this SHA (fix: these
  folders were referenced by `sync-governance.sh` but absent from the repo — the script ran
  silently as a no-op, `log_warn` without failure). `skills/` and `plugins/` remain
  deliberately empty: installed via `gh skills install` / `copilot plugin install` directly in
  the target environment, not copied as files into this repo.

## Distribution matrix by project type

See [docs/awesome-copilot-map.md](docs/awesome-copilot-map.md)

## Updating

When this repository is updated, rerun `sync-governance.sh` in the affected projects to propagate the changes.

```bash
# Update a project
cd /path/to/itshaker-bootstrap
./scripts/sync-governance.sh --type infra --dest /path/to/my-project --extend-only
```

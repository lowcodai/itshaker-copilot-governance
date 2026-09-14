# ADR — Architecture Decision Records de ce repo

Convention de numérotation : `ADR-NNNN-<slug>.md`, séquence propre à ce repo, à partir de 0001.
Ne jamais renuméroter un ADR accepté — un changement matériel crée un nouvel ADR qui supersède
l'ancien (voir le processus détaillé dans `itshaker-dgx-spark-V2/docs/adr/README.md`, à adapter
si ce repo a des besoins spécifiques).

Chaque ADR porte `authored_by` (frontier-model recommandé | local-model autorisé) et
`execution_mode` (hermes-solo | hermes-orchestrator-openhands) — voir
`templates/ADR-template.md` et `docs/methodology/PRD-ADR-PLAN-RUNBOOK-WORKFLOW.md`.

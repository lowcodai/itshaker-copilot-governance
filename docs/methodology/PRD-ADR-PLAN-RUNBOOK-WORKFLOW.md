> **Langue de ce corpus :** ce dépôt de gouvernance (templates, agents, méthodologie) reste
> rédigé en français. Les documents *générés* dans un repo cible (PRD, ADR, AGENTS.md)
> suivent la langue déclarée par la section `## Language` du repo cible, jamais celle-ci —
> voir la règle de découplage dans `agents/prd-generator.agent.md` / `agents/adr-generator.agent.md`.

# Méthodologie — PRD → ADR → Plan → Runbook → Exécution automatisée

## Pourquoi cette chaîne

Un agent qui commence à coder sans PRD ni ADR optimise localement (le prochain fichier) sans
garantie de cohérence globale (pourquoi, quelle architecture, quelles limites). Cette chaîne
force la séparation entre **intention produit** (PRD), **décision technique** (ADR),
**décomposition exécutable** (Plan) et **détail opérationnel** (Runbook), afin qu'un agent en
inférence locale (Qwen3.8-27B-NVFP4 sur DGX Spark) puisse exécuter sans avoir à arbitrer de
questions ambiguës en cours de route — l'arbitrage a déjà eu lieu, en amont, dans l'ADR.

## La chaîne

1. **PRD** (`docs/prd/PRD-NNNN-<slug>.md`, `templates/PRD-template.{fr,en}.md`) — quoi/pourquoi,
   critères de succès, non-objectifs. Zéro détail d'implémentation.
2. **ADR** (`docs/adr/ADR-NNNN-<slug>.md`, `templates/ADR-template.{fr,en}.md`) — quelle décision
   technique, alternatives rejetées, conséquences, **et** le champ `execution_mode` qui fige le
   mode d'exécution retenu (voir ci-dessous).
3. **Plan** (skill `plan` / `writing-plans`, `.hermes/plans/*.md`) — décomposition en tâches de
   2-5 minutes, chemins de fichiers exacts, code complet, commandes de vérification. Créé en
   mode plan par un agent (Hermes ou GitHub Copilot).
4. **Runbook** (`docs/runbook/RUNBOOK-NNNN-<slug>.md`) — détail opérationnel séquencé, écrit
   avant l'exécution, jamais improvisé pendant.
5. **Exécution automatisée** — voir §Modes.

## Recommandation de niveau de modèle (non bloquante)

- **PRD et ADR : modèle frontière fortement recommandé** (Claude Sonnet 5, GPT-5.6 Sol ou
  équivalent) pour les décisions irréversibles, à fort enjeu (infra publique, données,
  sécurité, coût récurrent significatif).
- **Modèle local autorisé** (Qwen3.8-27B-NVFP4 / DGX Spark ou équivalent) pour des raisons de
  coût, en particulier sur des décisions réversibles, à faible enjeu, ou en itération rapide.
  Un PRD/ADR `authored_by: local-model` est un document **valide et exécutable** — ce n'est
  jamais un blocage d'outil ou d'agent, seulement une étiquette d'audit. Une relecture par
  modèle frontière est recommandée avant passage au statut "Accepté" si la décision est à fort
  enjeu, mais reste une recommandation, pas une porte bloquante.
- Le Plan et le Runbook n'ont pas cette recommandation : ils sont d'exécution, pas de décision.

## Modes d'exécution

### Mode A — Hermes Solo

Un agent Hermes endosse séquentiellement tous les rôles (architecte, dev, testeur, sécurité,
ops) dans son propre contexte, en suivant le Plan via la skill `subagent-driven-development`
(un sous-agent frais par tâche, revue spec puis qualité). Pas d'isolation sandbox par rôle —
isolation logique seulement (étapes séquentielles, revues intercalées).

**Choisir Mode A quand :**
- Le travail est mono-repo, mono-domaine, réversible.
- Pas besoin d'isolation forte entre rôles (ex: pas de séparation stricte dev/sécurité requise).
- Volume de travail limité (quelques heures, pas plusieurs jours-agents en parallèle).
- Coût/simplicité prioritaires sur l'isolation.

### Mode B — Hermes Orchestrateur + OpenHands

Hermes ne joue que le rôle **Orchestrateur** : il ne code pas lui-même, il délègue chaque rôle
(architecte, dev, testeur, sécurité, ops) à une **app-conversation OpenHands** distincte —
sandbox isolé, dépôt et branche propres, modèle `openai/dgx-spark-current` (vLLM DGX Spark).
La collaboration inter-rôles passe par des artefacts gouvernables (git/diff, branches,
rapports) relayés par l'Orchestrateur — jamais par une conversation agent-à-agent directe.
Ce pattern est **déjà accepté** par `ADR-0020` (`itshaker-dgx-spark-V2`, 2026-09-12) pour
`hermes-spark-builder` ; ce document en généralise les critères de sélection à tout projet
gouverné par `itshaker-copilot-governance`.

**Choisir Mode B quand :**
- Isolation stricte requise entre rôles (ex: le rôle sécurité doit pouvoir bloquer sans que le
  rôle dev puisse écraser son verdict dans le même contexte).
- Parallélisme réel recherché (plusieurs rôles/tâches en cours simultanément, sandboxes
  séparés).
- Enjeu élevé (infra publique, déploiement production, données sensibles) où la trace d'audit
  par conversation séparée a de la valeur.
- Le mécanisme de délégation existe déjà pour la cible (`oh_pilot.py` / skill
  `openhands-pilot`, disponible aujourd'hui sur `hermes-spark-builder`/DGX Spark).

**Prérequis Mode B (hérités d'ADR-0020, à vérifier avant de choisir ce mode) :**
- OpenHands opérationnel et qualifié sur la cible (voir skill `openhands-spark-ops` —
  limitations connues : pas de token GitHub configuré pour les conversations `--repo` au
  moment de la rédaction, id de tâche ≠ id de conversation statable).
- Le dépôt cible doit être accessible en `--repo`/`--branch` depuis OpenHands, ou le mode
  bascule de facto en Mode A pour les rôles qui en ont besoin.

## Ce que ce document ne décide pas

- Il ne redésigne pas `ADR-0020` ni son périmètre (`hermes-spark-builder` reste orchestrateur
  unique sur cette instance).
- Il ne rend Mode B disponible que là où le pilotage OpenHands existe réellement — un repo sans
  accès à `oh_pilot.py`/l'app OpenHands qualifiée doit choisir Mode A par défaut.

## Références

- `templates/PRD-template.{fr,en}.md`, `templates/ADR-template.{fr,en}.md`
- `agents/prd-generator.agent.md`, `agents/adr-generator.agent.md`
- Skills : `plan`, `writing-plans`, `subagent-driven-development`, `openhands-spark-ops`
- ADR source du pattern Mode B : `itshaker-dgx-spark-V2/docs/adr/ADR-0020-hermes-builder-openhands-orchestration.md`

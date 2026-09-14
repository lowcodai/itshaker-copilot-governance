# Plan — Méthodologie PRD → ADR → Plan → Runbook + 2 modes d'exécution (Hermes Solo / Orchestrateur+OpenHands)

**Statut :** À exécuter (plan mode — aucune modification faite par ce document lui-même)
**Repos concernés (côte à côte, prérequis déjà rempli) :**
- `/opt/data/workspace/itshaker-align/itshaker-copilot-governance` (source de vérité)
- `/opt/data/workspace/itshaker-align/itshaker-bootstrap` (scaffolding/sync)
- `/opt/data/workspace/itshaker-align/itshaker-dgx-spark-V2` (cible de validation dry-run, a déjà `docs/adr/`, pas de `docs/prd/`)

---

## Goal

Ajouter à la gouvernance itshaker un cycle documentaire obligatoire-mais-flexible
**PRD → ADR → Plan → Runbook → exécution automatisée**, avec (a) une préférence forte mais
non bloquante pour un modèle frontière sur PRD/ADR, et (b) deux modes d'exécution
sélectionnables — **Hermes Solo** (un agent endosse tous les rôles) et **Hermes
Orchestrateur + OpenHands** (rôles délégués à des app-conversations OpenHands séparées,
pattern déjà accepté par `ADR-0020` sur `itshaker-dgx-spark-V2`) — puis propager cette
méthodologie via `sync-governance.sh`.

## Ajustement (2026-09-14, retour Capitaine) — Aspect langue

**Constat vérifié :** `itshaker-copilot-governance` (43 fichiers `.md`, y compris tous les
templates/agents créés dans ce plan) est **100% français**. `itshaker-template-{base,infra,ai,app}`
génèrent leurs fichiers (`AGENTS.md`, `.github/copilot-instructions.md`, `CONTRIBUTING.md`,
`ROADMAP.md`) en français via des heredocs codés en dur dans `apply-template.sh`.
`itshaker-dgx-spark-V2/AGENTS.md` exige déjà l'anglais pour toute la documentation du repo
(`## Documentation Principles`, ligne 60), **sans exception** — confirmé par le Capitaine : ce
repo doit rester 100% anglais y compris pour tout PRD à venir (aucun PRD n'existe encore dans ce
repo, donc rien à traduire rétroactivement, seulement à cadrer avant le premier). `HermesVPS2` et
`ITShaker-llmwiki` sont français sans déclaration de langue explicite dans leur `AGENTS.md`/`.hermes.md`.

**Décision (Capitaine, 2026-09-14) :** pas de duplication de repos template. Paramétrer les
scripts avec un flag `--lang`, défaut **`en`** dès aujourd'hui (direction long terme = anglais
partout), garder des paires bilingues **bornées** au contenu littéral généré (pas de traduction
rétroactive du corpus meta français existant), et rendre la langue déclarative et explicite via
une section `## Language` obligatoire dans tout `AGENTS.md`.

Tâches ajoutées : 11 (flag `--lang`), 12 (paires bilingues PRD/ADR + heredocs), 13 (section
`## Language` dans le générateur `apply-template.sh`), 14 (rétro-application sur les 5 repos
existants, y compris la correction de l'exception PRD manquante sur `itshaker-dgx-spark-V2`).

---

## Current context / assumptions

- Vérifié : `itshaker-copilot-governance` n'a **aucun** `docs/adr/` ni `docs/prd/` — seulement
  `templates/ADR-template.md` (générique, pas de front-matter `authored_by`/`execution_mode`)
  et l'agent `agents/adr-generator.agent.md`. Aucun agent PRD n'existe.
- Vérifié : `itshaker-dgx-spark-V2` a un vrai `docs/adr/` (ADR-0001 → ADR-0020, séquence propre
  à ce repo) et **pas** de `docs/prd/`. `ADR-0020` documente déjà exactement le pattern Mode B :
  Builder = orchestrateur unique, rôles (`architecte`,`dev`,`testeur`,`securite`,`ops`) = profils
  SOUL délégués en app-conversations OpenHands isolées (sandbox + repo/branche propres), piloté
  par `oh_pilot.py`/skill `openhands-pilot`. Ce plan **étend** ce pattern déjà accepté à un
  mécanisme générique de sélection de mode, il ne le remplace pas.
- Vérifié : `sync-governance.sh` (`itshaker-bootstrap/scripts/`) a une fonction `sync_hermes()`
  qui scaffold `docs/operations/{CURRENT,HANDOFF,ACTIVITY}.md` via `copy_if_not_exists` (jamais
  d'écrasement). C'est le pattern à répliquer pour `docs/prd/` et `docs/adr/`.
- Vérifié : `awesome-copilot-bundles.yml` gouverne quels `agents/*.agent.md` sont copiés par type
  de projet (`base|infra|ai|app`) ; le générateur ADR est **commun** à tous les types
  (`bundles.common` implicite ligne 43-45), les agents `ai` sont dans `bundles.ai.agents`.
- Contrainte explicite du Capitaine (à ne pas violer) : **ne jamais imposer** un modèle frontière
  pour PRD/ADR — le recommander fortement, mais permettre la génération par un modèle local
  (Qwen3.8-27B-NVFP4 sur DGX Spark), pour des raisons de coût. Le gate est documentaire
  (front-matter `authored_by`), pas un blocage d'outil/agent.
- Ce plan ne propage PAS la méthodologie sur tous les repos consommateurs (ce sera un prochain
  cycle du `governance-alignment-runbook.md`, après validation sur `itshaker-dgx-spark-V2` en
  dry-run). Scope ici : **gouvernance + bootstrap + validation dry-run**, pas de push distant.

## Architecture / approche

Le PRD (quoi/pourquoi, sans détail d'implémentation) précède l'ADR (quelle décision technique,
alternatives, conséquences) ; les deux portent un champ front-matter `authored_by:
frontier-model (recommandé) | local-model` pour l'audit, jamais un blocage. Un champ
`execution_mode: hermes-solo | hermes-orchestrator-openhands` sur l'ADR fige le mode retenu
pour l'implémentation, décidé selon des critères explicites (isolation/parallélisme/enjeu vs
coût/simplicité). Le Plan (skill `plan`/`writing-plans`) traduit l'ADR en tâches ; le Runbook
détaille l'opérationnel ; l'exécution suit soit `subagent-driven-development` (Mode A) soit
`oh_pilot.py`/`openhands-pilot` par rôle (Mode B, pattern ADR-0020).

---

## Step-by-step tasks

### Tâche 1 — Créer `templates/PRD-template.md` dans `itshaker-copilot-governance`

Fichier : `/opt/data/workspace/itshaker-align/itshaker-copilot-governance/templates/PRD-template.md`

```markdown
# Modèle PRD

\`\`\`markdown
# PRD-XXXX — Titre du produit/de la fonctionnalité

**Date:** YYYY-MM-DD
**Statut:** Brouillon | En revue | Validé | Abandonné
**Auteurs:** <!-- Noms ou rôles -->
**authored_by:** frontier-model (recommandé) | local-model
<!-- frontier-model = Claude Sonnet 5 / GPT-5.6 Sol ou équivalent. local-model = Qwen3.8-27B-NVFP4
     (DGX Spark) ou tout modèle en inférence locale. Un PRD local-model est valide et exécutable ;
     ce champ sert uniquement l'audit et la priorisation de revue humaine, pas un blocage d'outil. -->
**Lié à ADR:** <!-- ADR-XXXX si déjà connu, sinon "à déterminer" -->

## Problème

<!-- Quel problème utilisateur/métier/opérationnel ce travail résout-il ? Pourquoi maintenant ? -->

## Non-objectifs

<!-- Ce qui est explicitement hors périmètre, pour éviter le scope creep. -->

## Critères de succès

<!-- Mesurables. "Ça marche" n'est pas un critère. -->

## Utilisateurs / parties prenantes

<!-- Qui est affecté, qui décide, qui valide. -->

## Contraintes connues

<!-- Techniques, opérationnelles, de coût (ex: doit tourner en inférence sur DGX Spark). -->

## Hors périmètre de ce document

<!-- Le PRD ne décrit PAS la solution technique — c'est le rôle de l'ADR qui suit. -->
\`\`\`
```

**Vérification :** `test -f templates/PRD-template.md && echo OK`

---

### Tâche 2 — Ajouter `authored_by` et `execution_mode` à `templates/ADR-template.md`

Fichier : `/opt/data/workspace/itshaker-align/itshaker-copilot-governance/templates/ADR-template.md`

Insérer après la ligne `**Contexte technique:**` (avant `## Contexte`) :

```markdown
**authored_by:** frontier-model (recommandé) | local-model
<!-- Voir PRD-template.md pour la définition. Un ADR local-model reste valide ; documenter le
     choix pour l'audit et pour signaler qu'une relecture par modèle frontière est recommandée
     avant "Accepté" si la décision est irréversible ou à fort enjeu (infra publique, données,
     coût récurrent significatif). -->
**execution_mode:** hermes-solo | hermes-orchestrator-openhands
<!-- hermes-solo: un agent Hermes endosse séquentiellement tous les rôles (architecte/dev/
     testeur/sécurité/ops) dans son propre contexte — via subagent-driven-development.
     hermes-orchestrator-openhands: Hermes ne joue que le rôle Orchestrateur et délègue chaque
     rôle à une app-conversation OpenHands isolée (sandbox + repo/branche propres) — pattern
     accepté par ADR-0020 (itshaker-dgx-spark-V2), piloté via oh_pilot.py / skill openhands-pilot.
     Critères de choix : voir docs/methodology/PRD-ADR-PLAN-RUNBOOK-WORKFLOW.md §Modes. -->
```

**Vérification :** `grep -n "execution_mode" templates/ADR-template.md` doit renvoyer une ligne.

---

### Tâche 3 — Créer le document de méthodologie

Fichier :
`/opt/data/workspace/itshaker-align/itshaker-copilot-governance/docs/methodology/PRD-ADR-PLAN-RUNBOOK-WORKFLOW.md`

```markdown
# Méthodologie — PRD → ADR → Plan → Runbook → Exécution automatisée

## Pourquoi cette chaîne

Un agent qui commence à coder sans PRD ni ADR optimise localement (le prochain fichier) sans
garantie de cohérence globale (pourquoi, quelle architecture, quelles limites). Cette chaîne
force la séparation entre **intention produit** (PRD), **décision technique** (ADR),
**décomposition exécutable** (Plan) et **détail opérationnel** (Runbook), afin qu'un agent en
inférence locale (Qwen3.8-27B-NVFP4 sur DGX Spark) puisse exécuter sans avoir à arbitrer de
questions ambiguës en cours de route — l'arbitrage a déjà eu lieu, en amont, dans l'ADR.

## La chaîne

1. **PRD** (`docs/prd/PRD-NNNN-<slug>.md`, `templates/PRD-template.md`) — quoi/pourquoi,
   critères de succès, non-objectifs. Zéro détail d'implémentation.
2. **ADR** (`docs/adr/ADR-NNNN-<slug>.md`, `templates/ADR-template.md`) — quelle décision
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

- `templates/PRD-template.md`, `templates/ADR-template.md`
- `agents/prd-generator.agent.md`, `agents/adr-generator.agent.md`
- Skills : `plan`, `writing-plans`, `subagent-driven-development`, `openhands-spark-ops`
- ADR source du pattern Mode B : `itshaker-dgx-spark-V2/docs/adr/ADR-0020-hermes-builder-openhands-orchestration.md`
```

**Vérification :** `test -f docs/methodology/PRD-ADR-PLAN-RUNBOOK-WORKFLOW.md && wc -l docs/methodology/PRD-ADR-PLAN-RUNBOOK-WORKFLOW.md`

---

### Tâche 4 — Créer l'agent `agents/prd-generator.agent.md`

Fichier : `/opt/data/workspace/itshaker-align/itshaker-copilot-governance/agents/prd-generator.agent.md`

```markdown
---
name: 'PRD Generator'
description: 'Expert agent for creating Product Requirement Documents (PRD) — problem, non-goals, success criteria — before any ADR or implementation. Use when: starting a new project, feature, or major change that needs intent documented before technical decisions.'
tools: ['search', 'read', 'edit']
---

# PRD Generator Agent

Vous créez des PRD structurés, en amont de toute décision technique (ADR). Un PRD frontière est
recommandé pour les décisions à fort enjeu, mais un PRD par modèle local (Qwen3.8-27B-NVFP4 /
DGX Spark) est valide et exécutable — voir `docs/methodology/PRD-ADR-PLAN-RUNBOOK-WORKFLOW.md`.

## Core Workflow

1. **Collecter** : problème, non-objectifs, critères de succès mesurables, parties prenantes,
   contraintes connues. Si une information manque, la demander avant de continuer.
2. **Déterminer le numéro** : vérifier `docs/prd/`, prendre le prochain numéro séquentiel à 4
   chiffres (créer le dossier et commencer à 0001 s'il n'existe pas).
3. **Renseigner `authored_by`** honnêtement (`frontier-model` ou `local-model`, selon le modèle
   qui exécute cet agent) — jamais laisser vide.
4. **Générer** le PRD complet depuis `templates/PRD-template.md`, sauvegarder dans
   `docs/prd/PRD-NNNN-<slug>.md`.
5. **Ne pas** inclure de détail d'implémentation ni d'architecture — c'est le rôle de l'ADR qui
   suivra (agent `adr-generator`).

## Naming

`PRD-NNNN-<slug>.md`, slug en minuscules, tirets, 3-5 mots.

## Success Criteria

- Fichier créé dans `docs/prd/` avec numérotation correcte et séquentielle.
- Tous les champs front-matter renseignés, `authored_by` honnête.
- Aucun détail de solution technique dans le document (renvoi explicite vers l'ADR à venir).
```

**Vérification :** `test -f agents/prd-generator.agent.md && echo OK`

---

### Tâche 5 — Patcher `agents/adr-generator.agent.md` : ajouter authored_by/execution_mode

Dans `/opt/data/workspace/itshaker-align/itshaker-copilot-governance/agents/adr-generator.agent.md`,
remplacer le bloc front matter (section `### Front Matter`) :

Ancien :
```yaml
---
title: "ADR-NNNN: [Decision Title]"
status: "Proposed"
date: "YYYY-MM-DD"
authors: "[Stakeholder Names/Roles]"
tags: ["architecture", "decision"]
supersedes: ""
superseded_by: ""
---
```

Nouveau :
```yaml
---
title: "ADR-NNNN: [Decision Title]"
status: "Proposed"
date: "YYYY-MM-DD"
authors: "[Stakeholder Names/Roles]"
authored_by: "frontier-model | local-model"  # honnête, jamais vide — voir docs/methodology/PRD-ADR-PLAN-RUNBOOK-WORKFLOW.md
execution_mode: "hermes-solo | hermes-orchestrator-openhands"  # figé avant Implementation Notes
tags: ["architecture", "decision"]
supersedes: ""
superseded_by: ""
---
```

Ajouter aussi, juste avant `### 2. Determine ADR Number`, un point :

```markdown
### 1bis. Vérifier l'existence d'un PRD associé

Si un PRD (`docs/prd/PRD-NNNN-*.md`) existe pour ce travail, le lier dans les Références.
Si aucun PRD n'existe et que la décision porte sur une nouvelle fonctionnalité/produit (pas un
correctif technique interne), suggérer d'en créer un d'abord via l'agent `prd-generator` — sans
bloquer : une décision technique interne (dette, refactor, infra) n'exige pas de PRD.
```

**Vérification :** `grep -n "execution_mode" agents/adr-generator.agent.md` doit renvoyer ≥1 ligne.

---

### Tâche 6 — Créer les stubs génériques `docs/prd/README.md` et `docs/adr/README.md`

Ces fichiers sont copiés (jamais écrasés — `copy_if_not_exists`) dans les repos consommateurs
qui n'ont pas encore de README dans ces dossiers (ex: `itshaker-dgx-spark-V2` a déjà un vrai
`docs/adr/README.md` → restera en `[SKIP]`).

Fichier : `/opt/data/workspace/itshaker-align/itshaker-copilot-governance/hermes/docs-prd-templates/README.md`

```markdown
# PRD — Product Requirement Documents de ce repo

Convention de numérotation : `PRD-NNNN-<slug>.md`, séquence propre à ce repo, à partir de 0001.

Un PRD documente le **problème et les critères de succès**, pas la solution technique — voir
`templates/PRD-template.md` et l'agent `prd-generator`. La solution technique est décidée dans
un ADR associé (`docs/adr/`), qui référence ce PRD.

Méthodologie complète : voir `docs/methodology/PRD-ADR-PLAN-RUNBOOK-WORKFLOW.md` dans
`itshaker-copilot-governance` (ou sa copie locale si synchronisée dans ce repo).
```

Fichier : `/opt/data/workspace/itshaker-align/itshaker-copilot-governance/hermes/docs-adr-templates/README.md`

```markdown
# ADR — Architecture Decision Records de ce repo

Convention de numérotation : `ADR-NNNN-<slug>.md`, séquence propre à ce repo, à partir de 0001.
Ne jamais renuméroter un ADR accepté — un changement matériel crée un nouvel ADR qui supersède
l'ancien (voir le processus détaillé dans `itshaker-dgx-spark-V2/docs/adr/README.md`, à adapter
si ce repo a des besoins spécifiques).

Chaque ADR porte `authored_by` (frontier-model recommandé | local-model autorisé) et
`execution_mode` (hermes-solo | hermes-orchestrator-openhands) — voir
`templates/ADR-template.md` et `docs/methodology/PRD-ADR-PLAN-RUNBOOK-WORKFLOW.md`.
```

**Vérification :** `test -f hermes/docs-prd-templates/README.md && test -f hermes/docs-adr-templates/README.md && echo OK`

---

### Tâche 7 — Rédiger l'ADR-0001 de `itshaker-copilot-governance` (dogfooding)

`itshaker-copilot-governance` n'a pas encore de `docs/adr/` — cette méthodologie est elle-même
une décision d'architecture pour ce repo, donc premier ADR de sa propre séquence.

Fichier :
`/opt/data/workspace/itshaker-align/itshaker-copilot-governance/docs/adr/ADR-0001-prd-adr-plan-runbook-methodology.md`

Utiliser `templates/ADR-template.md` (mis à jour à la Tâche 2). Contenu minimal attendu :

- **Statut :** Proposé
- **authored_by :** frontier-model (cet ADR est rédigé par Claude Sonnet 5 dans ce plan)
- **execution_mode :** hermes-solo (l'implémentation de ce plan lui-même se fait en Mode A —
  pas de délégation OpenHands nécessaire pour du travail documentaire/gouvernance)
- **Contexte :** absence de convention PRD/ADR dans la gouvernance itshaker ; besoin de séparer
  intention (PRD), décision (ADR), exécution (Plan/Runbook) pour des agents en inférence locale.
- **Décision :** adopter la chaîne PRD→ADR→Plan→Runbook avec recommandation non bloquante de
  modèle frontière, et les deux modes d'exécution Hermes Solo / Orchestrateur+OpenHands
  (référence explicite à `ADR-0020` de `itshaker-dgx-spark-V2` comme pattern source du Mode B).
- **Alternatives rejetées :** (a) imposer un modèle frontière obligatoire pour PRD/ADR — rejeté
  pour raisons de coût opérationnel (Capitaine, 2026-09-14) ; (b) un seul mode d'exécution
  unique — rejeté car Mode A et Mode B répondent à des besoins d'isolation différents.
- **Conséquences positives :** traçabilité intention→décision→exécution ; flexibilité de coût ;
  généralisation d'un pattern déjà validé (ADR-0020).
- **Conséquences négatives :** charge documentaire supplémentaire avant tout travail ; risque de
  PRD/ADR de qualité inégale si systématiquement rédigés en local-model sans relecture.
- **Références :** `itshaker-dgx-spark-V2/docs/adr/ADR-0020-...`, `docs/methodology/PRD-ADR-PLAN-RUNBOOK-WORKFLOW.md`.

**Vérification :** `head -5 docs/adr/ADR-0001-prd-adr-plan-runbook-methodology.md` affiche le titre.

---

### Tâche 8 — Ajouter `sync_methodology()` à `sync-governance.sh`

Fichier : `/opt/data/workspace/itshaker-align/itshaker-bootstrap/scripts/sync-governance.sh`

Insérer une nouvelle fonction après `sync_hermes()` (avant `sync_templates()`), et l'appeler
dans `main()` :

```bash
# Synchronise la méthodologie PRD/ADR/Plan/Runbook depuis governance.
# Commune à tous les types de projet — la méthodologie ne dépend pas de base|infra|ai|app.
sync_methodology() {
  log_section "Synchronisation de la méthodologie PRD/ADR/Plan/Runbook"
  local src="${GOVERNANCE_DIR}"

  run_cmd mkdir -p "${DEST_DIR}/docs/prd" "${DEST_DIR}/docs/adr" "${DEST_DIR}/docs/methodology"

  [[ -f "${src}/hermes/docs-prd-templates/README.md" ]] && \
    copy_if_not_exists "${src}/hermes/docs-prd-templates/README.md" "${DEST_DIR}/docs/prd/README.md" || true
  [[ -f "${src}/hermes/docs-adr-templates/README.md" ]] && \
    copy_if_not_exists "${src}/hermes/docs-adr-templates/README.md" "${DEST_DIR}/docs/adr/README.md" || true
  [[ -f "${src}/docs/methodology/PRD-ADR-PLAN-RUNBOOK-WORKFLOW.md" ]] && \
    copy_if_not_exists "${src}/docs/methodology/PRD-ADR-PLAN-RUNBOOK-WORKFLOW.md" \
      "${DEST_DIR}/docs/methodology/PRD-ADR-PLAN-RUNBOOK-WORKFLOW.md" || true

  run_cmd mkdir -p "${DEST_DIR}/.github/agents"
  [[ -f "${src}/agents/prd-generator.agent.md" ]] && \
    copy_if_not_exists "${src}/agents/prd-generator.agent.md" "${DEST_DIR}/.github/agents/prd-generator.agent.md" || true
}
```

Dans `main()`, ajouter l'appel juste après `sync_hermes` :

```bash
  sync_hermes
  sync_methodology
```

**Vérification :** `bash -n scripts/sync-governance.sh` (syntaxe) → pas d'erreur ; puis
`grep -n "sync_methodology" scripts/sync-governance.sh` → doit apparaître à la fois en
définition et en appel dans `main()`.

---

### Tâche 9 — Enregistrer `prd-generator` dans `awesome-copilot-bundles.yml`

Fichier : `/opt/data/workspace/itshaker-align/itshaker-bootstrap/config/awesome-copilot-bundles.yml`

Le générateur ADR est copié pour tous les types (ligne 43-45, hors du bloc `bundles.<type>`).
Ajouter `prd-generator` au même endroit (même logique — commun à tous types) :

```yaml
      file: adr-generator.agent.md
      file: prd-generator.agent.md
```

(Adapter à la structure YAML réelle observée — insérer une entrée sœur de celle de
`adr-generator`, même niveau d'indentation, pas dans un bloc `bundles.<type>` spécifique.)

**Vérification :** `python3 -c "import yaml; yaml.safe_load(open('config/awesome-copilot-bundles.yml'))" && echo OK`

---

### Tâche 10 — Mettre à jour `governance-alignment-runbook.md`

Fichier :
`/opt/data/workspace/itshaker-align/itshaker-bootstrap/docs/governance-alignment-runbook.md`

Ajouter une étape après l'Étape 2 (dry-run) existante :

```markdown
## Étape 2bis — Vérifier la méthodologie PRD/ADR dans le dry-run

Dans la sortie de l'Étape 2, confirmer la présence de ces lignes (nouvelles depuis l'ajout de
`sync_methodology()`) :

\`\`\`text
[CREATE] docs/prd/README.md        (ou [SKIP] si le repo cible en a déjà un)
[CREATE] docs/adr/README.md        (ou [SKIP] — ex: itshaker-dgx-spark-V2 en a déjà un réel)
[CREATE] docs/methodology/PRD-ADR-PLAN-RUNBOOK-WORKFLOW.md
[CREATE] .github/agents/prd-generator.agent.md
\`\`\`

Si un repo cible a déjà un `docs/adr/README.md` réel et daté (ex: `itshaker-dgx-spark-V2`), il
**doit** apparaître en `[SKIP]`, jamais en `[CREATE]` — sinon `--extend-only` a régressé.
```

**Vérification :** `grep -n "Étape 2bis" docs/governance-alignment-runbook.md` → 1 résultat.

---

### Tâche 11 — Ajouter le flag `--lang en|fr` à `apply-template.sh` et `sync-governance.sh`

Défaut **`en`** (direction long terme). `fr` reste disponible pour les repos qui poursuivent
une ligne déjà française (aucune migration forcée d'un repo existant).

Fichier : `/opt/data/workspace/itshaker-align/itshaker-bootstrap/scripts/apply-template.sh`

Après la ligne `TEMPLATE_TYPE=""` (déclaration des variables), ajouter :

```bash
LANG_CODE="en"   # défaut: anglais. Override: --lang fr pour continuer une ligne française existante.
```

Dans la boucle `while [[ $# -gt 0 ]]; do ... case "$1" in`, ajouter une entrée sœur de `-t|--type` :

```bash
      -l|--lang)      LANG_CODE="$2"; shift 2 ;;
```

Après la validation `--type requis` existante, ajouter une garde :

```bash
if [[ "$LANG_CODE" != "en" && "$LANG_CODE" != "fr" ]]; then
  log_error "--lang doit être 'en' ou 'fr' (reçu: ${LANG_CODE})"
  exit 1
fi
```

Répliquer les 3 mêmes ajouts (variable, flag `-l|--lang`, garde) dans
`/opt/data/workspace/itshaker-align/itshaker-bootstrap/scripts/sync-governance.sh` et dans
`/opt/data/workspace/itshaker-align/itshaker-bootstrap/scripts/new-project.sh` (qui doit aussi
relayer `--lang` à `apply-template.sh` dans son tableau `args=(...)`, au même endroit que
`"--type" "$TEMPLATE_TYPE"`).

**Vérification :** `bash -n scripts/apply-template.sh && bash -n scripts/sync-governance.sh && bash -n scripts/new-project.sh` → aucune erreur ;
`./scripts/apply-template.sh --type base --name test --dest /tmp/x --dry-run 2>&1 | grep -q .` puis
relancer avec `--lang fr` pour confirmer que l'argument est accepté sans erreur `--lang doit être`.

---

### Tâche 12 — Bilinguiser les heredocs générés et créer `PRD-template.en.md` / `ADR-template.en.md`

Portée volontairement **bornée** : uniquement le contenu littéral copié dans un repo cible, pas
le corpus meta (agents, méthodologie) qui reste français pour l'instant (règle de découplage —
voir Tâche 13).

**12a — Templates PRD/ADR bilingues** dans `itshaker-copilot-governance/templates/` :
- Renommer l'actuel `templates/PRD-template.md` → `templates/PRD-template.fr.md` (créé à la
  Tâche 1 ; s'il n'a pas encore été committé, simplement le nommer ainsi directement).
- Créer `templates/PRD-template.en.md` : traduction fidèle de la Tâche 1 (mêmes sections :
  Problem, Non-goals, Success criteria, Stakeholders, Known constraints, Out of scope — mêmes
  champs front-matter `authored_by`/`Linked to ADR`).
- Renommer `templates/ADR-template.md` (mis à jour Tâche 2) → `templates/ADR-template.fr.md`.
- Créer `templates/ADR-template.en.md` : même structure traduite, `authored_by`/`execution_mode`
  gardés en anglais dans les deux versions (ce sont des valeurs de champ, pas du texte narratif).

**12b — Heredocs d'`apply-template.sh` bilingues.** Pour chacun des 4 blocs identifiés
(`AGENTS.md` ligne ~233, `.github/copilot-instructions.md` ligne ~398, `CONTRIBUTING.md` ligne
~257, `ROADMAP.md` ligne ~213), dupliquer le heredoc sous un bloc conditionnel :

```bash
  if [[ "$LANG_CODE" == "en" ]]; then
    cat > "${DEST_DIR}/AGENTS.md" << 'EOF'
# Copilot Agents

This file lists the GitHub Copilot agents available in this project.
Source: [github/awesome-copilot](https://github.com/github/awesome-copilot)

## Installed agents

| Agent | Description | File |
|-------|-------------|------|
| ADR Generator | Generates Architecture Decision Records | `.github/agents/adr-generator.agent.md` |
| PRD Generator | Generates Product Requirement Documents | `.github/agents/prd-generator.agent.md` |

## Usage

In GitHub Copilot Chat, reference an agent with `@<agent-name>`.
Custom agents are automatically available via their `.agent.md` files.
EOF
  else
    cat > "${DEST_DIR}/AGENTS.md" << 'EOF'
# Agents Copilot
[... bloc français existant inchangé ...]
EOF
  fi
```

Répéter le même pattern `if/else` sur `LANG_CODE` pour les 3 autres heredocs (traduire chaque
bloc anglais fidèlement, garder le bloc français existant tel quel dans la branche `else`).

**Vérification :** `bash -n scripts/apply-template.sh` ; puis dry-run réel :
`./scripts/apply-template.sh --type base --name test-en --dest /tmp/test-en --lang en` et
inspecter `/tmp/test-en/AGENTS.md` → doit être en anglais ; `--lang fr` sur `/tmp/test-fr` → doit
rester identique au comportement actuel (regression check).

---

### Tâche 13 — Règle de découplage langue-instruction / langue-livrable + section `## Language` obligatoire

**13a —** Dans `agents/prd-generator.agent.md` (Tâche 4) et `agents/adr-generator.agent.md`
(Tâche 5), ajouter sous `## Core Workflow`, en tête, avant l'étape 1 :

```markdown
## Langue de sortie (ne jamais confondre avec la langue de cette instruction)

Toujours écrire le document généré (PRD/ADR) dans la langue déclarée par la section
`## Language` de l'`AGENTS.md` du repo cible — jamais dans la langue de ce fichier d'instructions.
Si `AGENTS.md` déclare une exception spécifique au type de document (ex: "PRD reste en français"),
respecter l'exception. Si aucune section `## Language` n'existe dans le repo cible, demander
avant de générer plutôt que de supposer.
```

**13b —** Dans `apply-template.sh`, le heredoc `AGENTS.md` (Tâche 12b, les deux branches
`en`/`fr`) doit systématiquement inclure une section `## Language` générée selon `$LANG_CODE` :

```bash
  if [[ "$LANG_CODE" == "en" ]]; then
    LANG_SECTION=$'## Language\n\nAll repository documentation is written in English (ADRs, PRDs, runbooks, README, code comments). No retroactive translation required for pre-existing content.'
  else
    LANG_SECTION=$'## Language\n\nDocumentation de ce dépôt en français (héritage). Pas de traduction rétroactive exigée.'
  fi
```

Puis interpoler `${LANG_SECTION}` dans le heredoc `AGENTS.md` (Tâche 12b), juste après le titre.

**Vérification :** `grep -n "## Language" /tmp/test-en/AGENTS.md /tmp/test-fr/AGENTS.md` → 1
résultat par fichier.

---

### Tâche 14 — Rétro-application de la section `## Language` sur les 5 repos existants (sans traduction)

Aucune traduction rétroactive du contenu existant — uniquement ajout d'une section déclarative.

1. **`itshaker-dgx-spark-V2/AGENTS.md`** — **pas d'exception** : le Capitaine confirme que ce
   repo doit rester 100% anglais, PRD inclus (aucune tolérance français ici, contrairement à
   l'hypothèse initiale de ce plan). `docs/prd/hermes-builder-capability-platform.md` existait
   déjà en français et a été traduit intégralement le 2026-09-14 (commit `6d9af4c`, aucun
   changement de contenu) — le repo est désormais conforme.
   Ajouter sous `# Documentation Principles` (ligne 58-60), juste après la ligne `**All repository
   documentation is written in English.**` :
   ```markdown
   **No exceptions.** This applies to every document type without exception, including PRDs —
   use `templates/PRD-template.en.md` (never the French variant) for any PRD created in this repo.
   ```
2. **`HermesVPS2/.hermes.md`** — ajouter en tête (après le H1) :
   ```markdown
   ## Language

   Documentation de ce dépôt en français (héritage). Pas de traduction rétroactive exigée.
   ```
3. **`ITShaker-llmwiki/AGENTS.md`** — même bloc `## Language` (français, héritage), inséré après
   le H1 `# AGENTS.md — Instructions pour agents LLM (GitHub Copilot)`.
4. **`itshaker-copilot-governance`** — n'a pas d'`AGENTS.md` propre à la racine (c'est la source
   de gouvernance, pas un repo applicatif) ; ajouter plutôt en tête de
   `docs/methodology/PRD-ADR-PLAN-RUNBOOK-WORKFLOW.md` (Tâche 3) une note :
   ```markdown
   > **Langue de ce corpus :** ce dépôt de gouvernance (templates, agents, méthodologie) reste
   > rédigé en français. Les documents *générés* dans un repo cible (PRD, ADR, AGENTS.md)
   > suivent la langue déclarée par la section `## Language` du repo cible, jamais celle-ci —
   > voir la règle de découplage dans `agents/prd-generator.agent.md` / `agents/adr-generator.agent.md`.
   ```
5. **`itshaker-template-{base,infra,ai,app}/.hermes.md`** (les 4 repos) — ajouter, après le H1
   `# Operational Continuity Contract — <repo>` :
   ```markdown
   ## Language

   Ce template génère désormais en anglais par défaut (`--lang en`, voir `apply-template.sh`).
   Le contenu actuel de ce `.hermes.md`/`README.md` reste français (héritage, pas de traduction
   rétroactive) ; tout nouveau repo créé via le bootstrap reçoit sa langue selon `--lang`.
   ```

**Vérification :** `grep -rln "## Language" itshaker-dgx-spark-V2/AGENTS.md HermesVPS2/.hermes.md ITShaker-llmwiki/AGENTS.md itshaker-template-{base,infra,ai,app}/.hermes.md` →
7 fichiers listés ; `grep -n "No exceptions" itshaker-dgx-spark-V2/AGENTS.md` → 1 résultat (pas de
nouvelle section `## Language` propre sur ce repo, amendement de la section `Documentation
Principles` existante).

---

## Tests / validation

Pas de tests automatisés (travail de documentation/gouvernance) — validation par dry-run réel,
sans écriture, sur une cible qui a déjà `docs/adr/` mais pas `docs/prd/` :

```bash
cd /opt/data/workspace/itshaker-align/itshaker-bootstrap
DRY_RUN=true VERBOSE=true ./scripts/sync-governance.sh \
  --type infra \
  --dest ../itshaker-dgx-spark-V2 \
  --extend-only
```

**Attendu :**
- `[SKIP] .../docs/adr/README.md` (existe déjà, réel, ne doit jamais être marqué `[CREATE]`)
- `[CREATE] .../docs/prd/README.md`
- `[CREATE] .../docs/methodology/PRD-ADR-PLAN-RUNBOOK-WORKFLOW.md`
- `[CREATE] .../.github/agents/prd-generator.agent.md`
- Aucune ligne `[CREATE]` sur un fichier `docs/adr/ADR-000*.md` existant.

Si l'un de ces points diverge : **ne pas exécuter en réel**, revenir sur la Tâche 8
(`sync_methodology()`) avant de committer quoi que ce soit.

Une fois le dry-run conforme : commit dans `itshaker-copilot-governance` et
`itshaker-bootstrap` séparément (2 commits, 2 repos), **sans** exécuter le sync en réel sur
`itshaker-dgx-spark-V2` ou tout autre repo consommateur — cette propagation est un prochain
cycle explicite du `governance-alignment-runbook.md`, à valider avec le Capitaine avant push.

---

## Risks, tradeoffs, open questions

- **Risque qualité** : un PRD/ADR rédigé systématiquement en `local-model` sans relecture
  frontière peut dériver en documentation de façade. Mitigation documentée (recommandation
  forte + audit via `authored_by`) mais pas d'enforcement automatique — accepté explicitement
  par le Capitaine pour raison de coût.
- **Mode B dépend d'un prérequis externe non garanti** : `openhands-spark-ops` documente des
  limitations actives (pas de token GitHub pour `--repo`, bug `sandbox_spec_id`). Un repo qui
  choisit Mode B sans vérifier ces prérequis peut se retrouver bloqué en cours d'exécution —
  d'où le rappel explicite dans le §Modes de la méthodologie.
- **Ouverture** : faut-il un `execution_mode` par ADR (grain fin) ou un seul mode par repo (dans
  `.hermes.md`) ? Ce plan choisit le grain ADR (plus flexible, un repo peut mélanger les deux
  selon la décision) — à confirmer avec le Capitaine si un défaut par repo est préférable.
- **Ouverture** : ce plan ne propage pas encore la méthodologie sur les repos déjà alignés
  (HermesVPS2, ITShaker-llmwiki, templates ai/app/base/infra) — nécessite un nouveau passage du
  `governance-alignment-runbook.md`, décision du Capitaine sur le calendrier.
- **Aspect langue — tranché (Capitaine, 2026-09-14) :** défaut `--lang en` dès aujourd'hui pour
  tout nouveau repo scripté, pas de duplication de repos template, paires bilingues bornées au
  contenu littéral généré (Tâches 11-14). Reste ouvert : calendrier de bascule complète des repos
  français existants (HermesVPS2, ITShaker-llmwiki, governance) vers l'anglais — aucune traduction
  rétroactive n'est planifiée par ce plan, seulement la déclaration explicite de la langue actuelle.

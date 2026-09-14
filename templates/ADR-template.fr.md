# Modèle ADR

```markdown
# ADR-XXXX — Titre de la décision

**Date:** YYYY-MM-DD
**Statut:** Proposé | En cours | Accepté | Rejeté | Obsolète | Remplacé par ADR-YYYY
**Décideurs:** <!-- Noms ou rôles -->
**Contexte technique:** <!-- Stack, version, etc. -->
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

## Contexte

<!-- Décrire la situation, le problème ou le besoin qui nécessite cette décision.
     Inclure les contraintes et les forces en présence. -->

## Options considérées

| Option | Avantages | Inconvénients |
|--------|-----------|---------------|
| Option A | ... | ... |
| Option B | ... | ... |
| Option C | ... | ... |

## Décision

<!-- La décision prise et son justification.
     Format: "Nous choisissons **Option X** parce que..." -->

## Conséquences

### Positives
- ...

### Négatives
- ...

### Neutres / À surveiller
- ...

## Mise en œuvre

<!-- Étapes concrètes de mise en œuvre si applicable -->

## Références

- [Lien vers documentation]()
- [ADR liés](./ADR-XXXX.md)
```

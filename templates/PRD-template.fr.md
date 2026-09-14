# Modèle PRD

```markdown
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
```

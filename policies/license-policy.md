# Politique de Licences — itshaker

## Licence par défaut

Tous les repositories itshaker utilisent la licence **MIT** par défaut.

Pour les projets propriétaires ou sensibles : licence propriétaire explicite.

## Dépendances — licences autorisées

| Catégorie | Licences autorisées |
|-----------|-------------------|
| Open source | MIT, Apache 2.0, BSD 2-Clause, BSD 3-Clause, ISC, CC0 |
| Documentaire | CC BY 4.0, CC BY-SA 4.0 |
| Conditionnelle | LGPL (review requise — pas d'incorporation statique) |

## Licences interdites

- GPL v2/v3 : contamination du code propriétaire
- AGPL : restrictions sur les services réseau
- Commons Clause : restrictions commerciales
- Licences sans attribution claire

## Vérification automatique

Le hook `dependency-license-checker` vérifie les licences à chaque commit.

Configuration dans `.licensee.json` ou `.license-checker.yml` du projet.

## Procédure pour exception

1. Ouvrir une issue avec le label `policy: license-exception`
2. Décrire la dépendance et justifier l'exception
3. Obtenir l'approbation d'un maintainer
4. Documenter l'exception dans `SECURITY.md` du projet

## Éléments Awesome Copilot

Les éléments issus de `github/awesome-copilot` sont sous licence MIT.
Vérifier la licence de chaque élément avant usage.

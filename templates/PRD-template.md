# PRD template

```markdown
# PRD-XXXX — Product/feature title

**Date:** YYYY-MM-DD
**Status:** Draft | In review | Approved | Abandoned
**Authors:** <!-- Names or roles -->
**authored_by:** frontier-model (recommended) | local-model
<!-- frontier-model = Claude Sonnet 5 / GPT-5.6 Sol or equivalent. local-model = Qwen3.8-27B-NVFP4
     (DGX Spark) or any locally-hosted inference model. A local-model PRD is valid and
     executable; this field is for audit and human-review prioritization only, never a tooling
     gate. -->
**Linked ADR:** <!-- ADR-XXXX if already known, otherwise "to be determined" -->

## Problem

<!-- What user/business/operational problem does this work solve? Why now? -->

## Non-goals

<!-- Explicitly out of scope, to prevent scope creep. -->

## Success criteria

<!-- Measurable. "It works" is not a criterion. -->

## Users / stakeholders

<!-- Who is affected, who decides, who approves. -->

## Known constraints

<!-- Technical, operational, cost-related (e.g. must run on DGX Spark inference). -->

## Out of scope for this document

<!-- The PRD does NOT describe the technical solution — that is the role of the following ADR. -->
```

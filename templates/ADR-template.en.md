# ADR template

```markdown
# ADR-XXXX — Decision title

**Date:** YYYY-MM-DD
**Status:** Proposed | In progress | Accepted | Rejected | Deprecated | Superseded by ADR-YYYY
**Decision makers:** <!-- Names or roles -->
**Technical context:** <!-- Stack, version, etc. -->
**authored_by:** frontier-model (recommended) | local-model
<!-- See PRD-template.md for the definition. A local-model ADR remains valid; document the
     choice for audit purposes and to flag that a frontier-model review is recommended before
     "Accepted" if the decision is irreversible or high-stakes (public infra, data, significant
     recurring cost). -->
**execution_mode:** hermes-solo | hermes-orchestrator-openhands
<!-- hermes-solo: a single Hermes agent sequentially takes on every role (architect/dev/
     tester/security/ops) within its own context — via subagent-driven-development.
     hermes-orchestrator-openhands: Hermes only plays the Orchestrator role and delegates each
     role to an isolated OpenHands app-conversation (separate sandbox + repo/branch) — pattern
     accepted by ADR-0020 (itshaker-dgx-spark-V2), driven via oh_pilot.py / skill openhands-pilot.
     Selection criteria: see docs/methodology/PRD-ADR-PLAN-RUNBOOK-WORKFLOW.md §Modes. -->

## Context

<!-- Describe the situation, problem, or need driving this decision.
     Include the constraints and forces at play. -->

## Options considered

| Option | Pros | Cons |
|--------|------|------|
| Option A | ... | ... |
| Option B | ... | ... |
| Option C | ... | ... |

## Decision

<!-- The decision made and its justification.
     Format: "We choose **Option X** because..." -->

## Consequences

### Positive
- ...

### Negative
- ...

### Neutral / To monitor
- ...

## Implementation

<!-- Concrete implementation steps, if applicable -->

## References

- [Documentation link]()
- [Related ADRs](./ADR-XXXX.md)
```

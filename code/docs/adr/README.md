# Architecture Decision Records

These records capture decisions made **during implementation**. They are
subordinate to the programme-level register at
`docs/architecture/Unified_Healthcare_SaaS_ADR_Closure_Register_v1.0.xlsx`,
which remains the authority on ADR-001 … ADR-015.

An ADR here does one of two things:

- records how a **Closed** programme ADR was realised in code, or
- records a Wave-0 implementation decision that the programme register does not
  cover, and names the open ADR it defers to.

Three programme ADRs are **Decision Required** and marked as blocking:

| ADR | Decision | Blocks |
|---|---|---|
| ADR-005 | Event broker (Kafka-compatible vs NATS JetStream) | A3 / A11 |
| ADR-006 | Durable workflow engine | A11 |
| ADR-008 | Enterprise identity provider | A5 |

Wave-0 code therefore exposes a **seam** for each rather than a vendor choice.
The seams are listed in `docs/engineering/wave-0-status.md`.

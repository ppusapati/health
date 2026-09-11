# Architecture Decision Records

These records capture decisions made **during implementation**. They are
subordinate to the programme-level register at
`docs/architecture/Unified_Healthcare_SaaS_ADR_Closure_Register_v1.0.xlsx`,
which remains the authority on ADR-001 … ADR-015.

An ADR here does one of two things:

- records how a **Closed** programme ADR was realised in code, or
- records a Wave-0 implementation decision that the programme register does not
  cover, and names the open ADR it defers to.

Three programme ADRs were **Decision Required** and marked as blocking. Two are
now closed:

| ADR | Decision | Blocks | Status |
|---|---|---|---|
| ADR-005 | Event transport | A3 / A11 | **Closed** — [0005](0005-event-broker.md) |
| ADR-006 | Durable workflow engine | A11 | Decision Required |
| ADR-008 | Enterprise identity provider | A5 | **Closed** — [0008](0008-enterprise-identity-provider.md) |

Each was built behind a **seam** rather than a vendor choice, and both closures
confirmed the seam held: ADR-008 changed the composition root and the
`AUTH_MODE` switch; ADR-005 added one `store.Broker` implementation. No
downstream code moved for either. The remaining seams are listed in
`docs/engineering/wave-0-status.md`.

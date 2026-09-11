# Architecture Decision Records

These records capture decisions made **during implementation**. They are
subordinate to the programme-level register at
`docs/architecture/Unified_Healthcare_SaaS_ADR_Closure_Register_v1.0.xlsx`,
which remains the authority on ADR-001 … ADR-015.

An ADR here does one of two things:

- records how a **Closed** programme ADR was realised in code, or
- records a Wave-0 implementation decision that the programme register does not
  cover, and names the open ADR it defers to.

Four programme ADRs were open at the start of Wave 0. All four are now closed:

| ADR | Decision | Gate | Status |
|---|---|---|---|
| ADR-005 | Event transport | A3 / A11 | **Closed** — [0005](0005-event-broker.md) |
| ADR-006 | Durable workflow engine | A11 | **Closed for Waves 1–6** — [0006](0006-durable-workflow-engine.md) |
| ADR-007 | Rules engine | A11 | **Closed** — [0007](0007-rules-engine.md) |
| ADR-008 | Enterprise identity provider | A5 | **Closed** — [0008](0008-enterprise-identity-provider.md) |

Each was built behind a **seam** rather than a vendor choice, and every closure
confirmed the seam held: ADR-008 changed the composition root and the
`AUTH_MODE` switch, ADR-005 added one `store.Broker` implementation, and
ADR-006/007 kept their contracts unchanged while the implementation behind them
was finished. No downstream code moved for any of them.

Three of the four decided to build rather than adopt, which is a pattern worth
being suspicious of — so each records the **measured or observable condition**
that reopens it, rather than a promise to revisit. ADR-006 additionally names
Wave 7 as an unconditional reopening, because SRS-BPM-* is Wave-7 scope and this
decision does not attempt to satisfy it.

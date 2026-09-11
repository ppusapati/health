# Unified Healthcare SaaS Platform

## Overview

The **Unified Healthcare SaaS Platform** is a multi-tenant healthcare and life-sciences operating platform designed to unify:

- Hospital management and clinical operations
- Specialty and sub-specialty workflows
- Emergency, ICU, OT, anesthesia and nursing
- Laboratory, radiology, pathology and diagnostics
- Hospital and retail pharmacy
- Pharmaceutical supply-chain operations
- Insurance, TPA and NHCX workflows
- Patient applications, PHR, telemedicine and home healthcare
- RPM / IoMT
- SCADA / BMS / hospital command-center operations
- Finance, CRM, governance, research and academics
- AI/ML, workflow, rules, analytics and developer-platform capabilities
- SaaS implementation, migration, support and commercialization

The intended positioning is:

> **Hospital Operating System + Healthcare Commerce Network + Patient Health Platform**

The platform is designed to support deployments ranging from a clinic to a multi-hospital enterprise and network-scale healthcare ecosystems.

---

## Project Status

The up-front architecture, requirements and engineering specification baseline is complete.

### Controlled requirement baseline

- **8 SRS phases**
- **3,132 atomic requirements**
- **210 requirement families**
- **10 delivery waves — Wave 0 through Wave 9**

Every requirement is expected to trace through:

```text
DPR Capability
    ↓
SRS Requirement
    ↓
Wave / Epic / Feature
    ↓
Bounded Context
    ↓
Go Service / API
    ↓
Svelte / Flutter UX
    ↓
Data / Event / Integration
    ↓
Security / NFR
    ↓
Test Evidence
    ↓
Release
```

No requirement is considered complete merely because code exists. A requirement becomes complete only after the required verification evidence passes.

---

# Architecture

## Core Technology Stack

| Layer | Technology |
|---|---|
| Backend | Go |
| Backend architecture | Clean Architecture |
| Contracts | Protobuf |
| RPC | ConnectRPC |
| Primary database | PostgreSQL |
| SQL access | sqlc |
| Web | Svelte / SvelteKit + TypeScript |
| Mobile / field | Flutter |
| AI / ML | Rust |
| Events | Transactional outbox / inbox + durable event bus |
| Workflows | Durable workflow orchestration |
| Rules | Deterministic versioned rules |
| Object storage | S3-compatible |
| Search | OpenSearch / Elasticsearch-class |
| Observability | OpenTelemetry |
| Runtime | Kubernetes + IaC / controlled promotion |
| Edge / OT | Hospital edge + OT DMZ |

---

## Backend Request Path

```text
Svelte / Flutter
      ↓
Protobuf / ConnectRPC
      ↓
Transport Handler
      ↓
Application / Use Case
      ↓
Domain
      ↓
Repository Port
      ↓
sqlc
      ↓
PostgreSQL
```

The domain layer contains business rules and must not depend on SQL, HTTP, RPC, cloud SDKs or UI concerns.

---

## Core Architectural Principles

### Modular-monolith-first

Transactional healthcare domains begin as strongly separated modules inside a limited number of deployables.

A module is extracted into an independent service only when justified by:

- scale,
- security/compliance boundary,
- blast-radius isolation,
- data residency,
- independent ownership, or
- independent release cadence.

Microservices are not created merely because a domain “sounds like a service.”

### One authoritative owner

Every mutable business fact has exactly one authoritative bounded context.

Cross-domain communication occurs through:

- APIs,
- events,
- workflows, or
- governed read models.

Direct undocumented cross-domain database writes are prohibited.

### Configuration over forks

Specialty packs, workflows, forms, tariffs, rules, payer behavior and localization should be configuration-driven wherever practical.

Customer-specific source-code forks should be avoided.

### Safety before convenience

Clinical, financial and inventory correctness must remain deterministic.

AI may assist, recommend, summarize or draft, but must not silently become the authority for high-risk clinical, legal or financial decisions.

### Auditability

Finalized clinical, financial, inventory and consent records use:

- amendment,
- addendum,
- reversal, or
- new ledger entries

rather than destructive history modification.

---

# Major Platform Domains

The platform includes, among others:

### Core Hospital

- Tenant / organization / facility structure
- IAM
- EMPI / patient identity
- Scheduling and queues
- Encounters and episodes
- Clinical record
- Nursing
- CPOE / orders
- Medication
- Billing

### Hospital Operations

- Emergency
- ICU
- OT
- Anesthesia / PACU
- Blood bank
- CSSD
- Materials / procurement / inventory
- Biomedical engineering
- Infection control
- Quality
- MRD / HIM
- Dietetics
- Housekeeping
- Laundry
- Ambulance
- Mortuary
- Facilities

### Specialty Care

Specialty packs cover major medical and surgical specialties including cardiology, oncology, nephrology, dialysis, pediatrics, neonatology, neurology, gastroenterology, pulmonology, obstetrics, gynecology, orthopedics, urology, ENT, ophthalmology, psychiatry, transplant and others.

### Diagnostics

- LIS
- Microbiology
- Histopathology
- Molecular diagnostics
- RIS / imaging orchestration
- Diagnostic networks
- Teleradiology / telepathology
- Digital pathology / genomics support

### Pharmacy & Pharma Network

- Hospital pharmacy
- Retail pharmacy
- Drug / SKU / batch management
- FEFO
- Warehouse
- Manufacturer → C&F → distributor → stockist → pharmacist
- Automated pharma order ingestion
- OCR / extraction
- SKU matching
- Pricing / schemes
- Credit validation
- ATP / ATS
- Backorders
- Exception handling
- Logistics

### Insurance & Patient Ecosystem

- Eligibility
- Preauthorization
- Claims
- Denials / remittance
- NHCX integration
- Patient application
- PHR
- Consent
- ABDM / FHIR adapters
- Telemedicine
- Home healthcare
- RPM
- IoMT
- Ambulance / SOS
- Patient logistics

### Enterprise Platform

- Workflow
- Rules
- Forms / templates
- Terminology
- AI / ML
- Analytics / lakehouse
- API management
- Developer platform
- Cybersecurity
- SOC
- SRE
- DR / downtime
- Integration hub
- Master data
- SCADA / IoT / command center
- Multi-country configuration

### Enterprise Business

- Accounting
- Treasury
- Budgeting
- Costing
- Fixed assets
- CRM
- Referral management
- Contracts
- Legal / MLC
- GRC
- Research / clinical trials
- Biobank
- Academics
- CME
- Philanthropy

### SaaS Control Plane

- Accounts
- Subscriptions
- Entitlements
- Metering
- SaaS billing
- Implementation
- Migration
- Device / interface onboarding
- Training
- Adoption
- Support
- SLA
- Customer success
- Release / configuration promotion
- Partner governance
- Offboarding

---

# Delivery Waves

| Wave | Scope |
|---|---|
| **Wave 0** | Platform Foundation |
| **Wave 1** | Core Hospital |
| **Wave 2** | Hospital Operations |
| **Wave 3** | Diagnostics |
| **Wave 4** | Pharmacy & Pharma Network |
| **Wave 5** | Insurance & Patient Ecosystem |
| **Wave 6** | Specialty Packs |
| **Wave 7** | Enterprise Platform |
| **Wave 8** | Enterprise Business |
| **Wave 9** | SaaS Commercial & Rollout Control |

Requirement counts reconcile exactly:

```text
Wave 0   109
Wave 1   130
Wave 2   239
Wave 3   185
Wave 4   295
Wave 5   485
Wave 6   496
Wave 7   581
Wave 8   314
Wave 9   298
----------------
Total   3,132
```

---

# Recommended Documentation Structure

```text
docs/
│
├── governance/
│   ├── Master Index & Traceability Specification
│   └── Master Engineering Registry
│
├── dpr/
│   └── Expanded Master DPR
│
├── srs/
│   ├── Master SRS Phase 1
│   ├── ...
│   └── Master SRS Phase 8
│
├── architecture/
│   ├── Engineering Architecture Blueprint
│   ├── Domain, Data, API, Event & Security Architecture
│   ├── UX Architecture & Design System
│   └── ADR Closure Register
│
├── waves/
│   ├── wave_00_platform_foundation/
│   ├── wave_01_core_hospital/
│   ├── wave_02_hospital_operations/
│   ├── wave_03_diagnostics/
│   ├── wave_04_pharmacy_pharma/
│   ├── wave_05_insurance_patient/
│   ├── wave_06_specialties/
│   ├── wave_07_enterprise_platform/
│   ├── wave_08_enterprise_business/
│   └── wave_09_saas_control/
│
├── delivery/
│   └── Development Backlog & Release Plan
│
├── testing/
│   ├── Requirements Verification, Validation & Testing Master Plan
│   └── Master RTM / Test Matrix
│
└── code
```

---

# Key Controlled Documents

## Product / Requirements

1. Expanded Master DPR
2. Master SRS Phase 1–8
3. Master Index & Traceability Specification

## Engineering

4. Engineering Architecture Blueprint
5. Domain, Data, API, Event & Security Architecture Specification
6. UX Architecture & Design System Specification
7. Development Backlog & Release Plan
8. Requirements Verification, Validation & Testing Master Plan

## Wave Specifications

9. Wave 0 Platform Foundation Detailed Engineering Specification
10. Wave 1 Core Hospital Detailed Engineering Specification
11. Wave 2 Hospital Operations Detailed Engineering Specification
12. Wave 3 Diagnostics Detailed Engineering Specification
13. Wave 4 Pharmacy & Pharma Network Detailed Engineering Specification
14. Wave 5 Insurance & Patient Ecosystem Detailed Engineering Specification
15. Wave 6 Specialty Packs Detailed Engineering Specification
16. Wave 7 Enterprise Platform Detailed Engineering Specification
17. Wave 8 Enterprise Business Detailed Engineering Specification
18. Wave 9 SaaS Commercial & Rollout Control Detailed Engineering Specification

## Execution Control

19. Master Engineering Registry
20. Master RTM / Test Matrix
21. Wave 1 Executable Feature Backlog
22. ADR Closure Register

---

# Traceability

Each engineering artifact should reference canonical SRS IDs.

Example:

```text
SRS-MED-014
    ↓
EPIC-W1-MED
    ↓
FEAT-W1-MED-...
    ↓
MedicationService
    ↓
healthcare.medication.v1
    ↓
UX-MED-...
    ↓
TST-SRS-MED-014-UT-01
TST-SRS-MED-014-CT-01
TST-SRS-MED-014-CST-01
TST-SRS-MED-014-UAT-01
    ↓
VERIFIED
    ↓
RELEASED
```

Production work must not exist outside the controlled requirement/change system.

---

# Testing & Validation

The platform uses the following verification classes:

| Code | Test Type |
|---|---|
| UT | Unit / Domain |
| RIT | Repository Integration |
| CT | Contract |
| IT | Integration |
| UI | UI / Component |
| E2E | End-to-End |
| CST | Clinical Safety |
| SEC | Security / Privacy |
| A11Y | Accessibility |
| PERF | Performance / Reliability |
| DRT | Downtime / Disaster Recovery |
| MVT | Model Validation |
| MIG | Migration / Reconciliation |
| UAT | User Acceptance |
| REG | Regression |

A production release must not contain an in-scope requirement without the required verification evidence.

Safety-critical requirements require explicit negative-path and failure-mode testing.

---

# Security Model

Authorization is based on **RBAC + ABAC**, not simple role checks.

Authorization context can include:

- tenant,
- legal entity,
- facility,
- department,
- role,
- clinical privilege,
- patient relationship,
- care team,
- purpose of use,
- resource sensitivity,
- delegation,
- time / assignment,
- device / network context,
- break-glass state.

UI visibility is never considered authorization.

Every sensitive request must be authorized server-side.

---

# Multi-Tenancy

Tenant isolation is mandatory across:

- API
- application layer
- database
- cache
- search
- object storage
- events
- workflows
- jobs
- analytics
- administration

Cross-tenant negative tests are mandatory.

---

# Eventing

State changes and outbox events are committed atomically.

Consumers must support deduplication.

Canonical event envelope includes:

```text
event_id
event_type
schema_version
occurred_at
published_at
tenant_id
source
aggregate_type
aggregate_id
correlation_id
causation_id
actor
payload
```

Events represent facts and are immutable after publication.

---

# AI / ML

AI/ML services are implemented primarily in Rust and accessed through a governed Go AI gateway.

AI must not be placed in the atomic correctness path of:

- medication,
- financial posting,
- inventory movement,
- claims,
- consent,
- or core clinical state.

For high-risk use cases, AI output remains advisory or draft until confirmed by an authorized human.

Model version, intended use, provenance and human disposition must be auditable.

---

# Edge / SCADA

Hospital OT and plant safety must not depend on cloud availability.

The architecture uses:

```text
Cloud Platform
     ↓
Hospital Edge
     ↓
OT DMZ
     ↓
SCADA / BMS / Gateways
     ↓
Controllers / Field Devices
```

Cloud-to-OT control is read-only by default.

Command-capable integrations require explicit risk approval and local safety interlocks.

---

# Developer Workflow

Before implementing a feature:

```text
Requirement
    ↓
Workflow
    ↓
UX
    ↓
API
    ↓
Data Model
    ↓
Security
    ↓
Test Intent
    ↓
Development
```

A feature should not enter development until its Definition of Ready is satisfied.

Typical implementation sequence:

1. Identify canonical SRS requirement IDs.
2. Confirm owning bounded context.
3. Define workflow/state transitions.
4. Define UX behavior.
5. Define Protobuf RPCs/events.
6. Define aggregate/data model.
7. Define permissions and audit.
8. Define test cases.
9. Implement vertical slice.
10. Produce verification evidence.
11. Release through controlled gates.

---

# Wave 0 — Current Engineering Priority

Development should begin with Wave 0:

- Monorepo / bootstrap
- Protobuf / ConnectRPC platform
- Go Clean Architecture service skeleton
- PostgreSQL / sqlc framework
- Tenant / organization foundation
- Identity / authorization context
- Event backbone
- Workflow / rules PoC
- SvelteKit shell
- Flutter shell
- Observability
- DevSecOps
- Kubernetes / deployment
- Hospital edge prototype
- Architecture fitness tests

Wave 1 development can begin progressively as Wave-0 gates become available.

---

# ADRs

Some decisions intentionally require implementation evidence before final closure.

Important Wave-0 ADRs include:

- Event-broker selection
- Durable workflow-engine selection
- Identity-provider product selection

Architecture contracts remain stable while these technologies are evaluated through PoCs.

---

# Definition of Done

A feature is not done when coding is finished.

A feature is done when:

- code is reviewed,
- contracts are compatible,
- migrations are safe,
- security checks pass,
- tenant isolation passes,
- required tests pass,
- clinical-safety validation passes where applicable,
- observability is present,
- documentation/runbooks are updated,
- every included SRS requirement is Verified,
- and release evidence exists.

---

# Change Control

New scope must receive a controlled requirement/change identifier.

Architectural deviations require an ADR.

A released requirement may be:

- amended,
- superseded,
- deprecated, or
- reopened

but should never be silently altered without traceability.

---

# Guiding Rule

> **The documentation defines intent and engineering constraints.  
> The code implements that intent.  
> The test evidence proves it.  
> Traceability connects all three.**

---

## Version

**README baseline:** v1.0  
**Program baseline:** September 2026  

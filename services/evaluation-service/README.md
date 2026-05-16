# evaluation-service — Automated QA & Stress Testing

**Domain:** Quality Assurance
**Role:** Generate stress test images, calculate automated metrics, prepare review gallery

## Responsibilities

- Generate 6 stress test images using auto-generated prompts
- Calculate 4 automated quality metrics
- Prepare image gallery for human review (Gate 3)
- Provide score overlay for DS (technical view)

## 4 Automated Metrics

| Metric | Threshold | Measures | Method |
|---|---|---|---|
| **Trigger Activation** | > 0.80 | Does trigger reliably activate brand attribute? | CLIP similarity: generated vs reference |
| **LOCKED Fidelity** | > 0.85 | Are non-negotiable elements reproduced accurately? | Generate WITHOUT describing LOCKED → verify presence |
| **UNLOCKED Diversity** | > 0.70 | Can model vary contextual elements? | Generate varied scenes → measure visual distance |
| **Negative Control** | < 0.20 | Does attribute disappear without trigger? | Generate WITHOUT trigger → verify absence |

## Auto-Generated Test Prompts (6)

1. `{trigger} {class}` — baseline
2. `{trigger} {class} in a sunny park` — outdoor
3. `{trigger} {class} in a studio with white background` — controlled
4. `{trigger} {class} wearing a red jacket` — specific attribute
5. `A {class} in a park` — **negative control** (NO trigger)
6. `{trigger} {class} {campaign_brief}` — campaign context

## Key Endpoints

| Method | Path | Description | Auth |
|---|---|---|---|
| POST | `/api/v1/evaluations` | Create evaluation | Service |
| GET | `/api/v1/evaluations/{id}` | Status and results | JWT |
| GET | `/api/v1/evaluations/{id}/images` | Generated image gallery | JWT |
| GET | `/api/v1/evaluations/{id}/scores` | Aggregated metrics | JWT (DS) |

→ Full spec: [api-spec.yaml](api-spec.yaml) · Schema: [schema.sql](schema.sql)

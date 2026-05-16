# review-service — Approval Flow & Feedback Translation

**Domain:** Quality Assurance
**Role:** Manage the approval cycle between Creator and Data Scientist

## Responsibilities

- Present generated images to Creator for visual approval (Gate 3 — MANDATORY)
- Collect per-image votes (approve/reject) with visual pin comments
- Translate creative feedback into technical tasks automatically
- Trigger re-training loop when rejected with feedback

## Feedback Translation (Creative → Technical)

| Creator Feedback | Auto-Generated Technical Task | Severity |
|---|---|---|
| "Logo is blurry" | "Increase rank to 64. Re-train identity LoRA" | HIGH |
| "Colors are wrong" | "Check locked_terms for palette. Scan violations" | HIGH |
| "Strange pose" | "Add more varied pose images to dataset" | MEDIUM |
| "Too artificial" | "Reduce guidance_scale at inference. Test fewer steps" | LOW |
| "Face looks different" | "LOCKED violation probable. Scan captions for facial attributes" | CRITICAL |

These translations are **suggestions** — the DS has context to accept, modify, or ignore them.

## Review Cycle Status Machine

```
PENDING_REVIEW → IN_REVIEW → APPROVED | REJECTED | PARTIAL
                                          ↓
                              (Feedback → caption-service → re-train)
```

## Key Endpoints

| Method | Path | Description | Auth |
|---|---|---|---|
| POST | `/api/v1/review-cycles` | Create review cycle | Service |
| GET | `/api/v1/review-cycles/{id}` | Cycle details + images + votes | JWT |
| POST | `/api/v1/review-cycles/{id}/vote` | Creator votes on image | JWT (Creator) |
| POST | `/api/v1/review-cycles/{id}/finalize` | Finalize review decision | JWT (Creator) |
| GET | `/api/v1/review-cycles/{id}/feedback-tasks` | Technical tasks from feedback | JWT (DS) |

→ Full spec: [api-spec.yaml](api-spec.yaml) · Schema: [schema.sql](schema.sql)
